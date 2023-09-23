/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const firestore = admin.firestore();

exports.updateCollectionsOnSocietyUpdate = functions.firestore
  .document('/universities/university-of-warwick/societies/{societyId}')
  .onUpdate(async (change, context) => {
    const updatedSocietyData = change.after.data();
    const societyRef = change.after.ref;
    const updatedLogoUrl = updatedSocietyData.logo_url;
    const updatedSocietyName = updatedSocietyData.name;

    const eventsCollection = firestore.collection('/universities/university-of-warwick/events');
    const spotlightsCollection = firestore.collection('/universities/university-of-warwick/spotlights');
    const chatsCollection = firestore.collection('/universities/university-of-warwick/chats');
    const usersCollection = firestore.collection('/universities/university-of-warwick/users');

    // Update events
    const eventsSnapshot = await eventsCollection
      .where('society.ref', '==', societyRef)
      .get();

    // Update spotlights
    const spotlightsSnapshot = await spotlightsCollection
      .where('society.ref', '==', societyRef)
      .get();

    // Update chats
    const chatsSnapshot = await chatsCollection
      .where('society.ref', '==', societyRef)
      .get();

    // Update users
    const usersSnapshot = await usersCollection
      .where(`followed_societies.${societyRef.id}.ref`, '==', societyRef)
      .get();

    const batch = firestore.batch();

    // Update events
    eventsSnapshot.forEach((eventDoc) => {
      const eventRef = eventDoc.ref;
      batch.update(eventRef, {
        'society.logo_url': updatedLogoUrl,
        'society.name': updatedSocietyName
      });
    });

    // Update spotlights
    spotlightsSnapshot.forEach((spotlightDoc) => {
      const spotlightRef = spotlightDoc.ref;
      batch.update(spotlightRef, {
        'society.logo_url': updatedLogoUrl,
        'society.name': updatedSocietyName
      });
    });

    // Update chats
    chatsSnapshot.forEach((chatDoc) => {
      const chatRef = chatDoc.ref;
      batch.update(chatRef, {
        'society.logo_url': updatedLogoUrl,
        'society.name': updatedSocietyName
      });
    });

    // Update users
    usersSnapshot.forEach((userDoc) => {
      const userRef = userDoc.ref;
      batch.update(userRef, {
        [`followed_societies.${societyRef.id}.name`]: updatedSocietyName,
        [`followed_societies.${societyRef.id}.logo_url`]: updatedLogoUrl
      });
    });

    // Update society document
    batch.update(societyRef, {
      logo_url: updatedLogoUrl,
      name: updatedSocietyName
    });

    return batch.commit();
  });

  exports.sendEventUpdateNotification = functions.firestore
  .document('/universities/university-of-warwick/events/{eventId}')
  .onUpdate(async (change, context) => {
    const newValue = change.after.data(); // Updated event data
    const previousValue = change.before.data(); // Previous event data

    if (!newValue || !previousValue) {
      // Document data not available, exit
      return null;
    }

    // Convert timestamps to Date objects and compare
    const newStartTime = newValue.start_time.toDate();
    const newEndTime = newValue.end_time.toDate();
    const prevStartTime = previousValue.start_time.toDate();
    const prevEndTime = previousValue.end_time.toDate();

    // Check if neither title nor location, description, start_time, or end_time has been changed
    if (
      newValue.title === previousValue.title &&
      newValue.description === previousValue.description &&
      newStartTime.getTime() === prevStartTime.getTime() &&
      newEndTime.getTime() === prevEndTime.getTime() &&
      newValue.location === previousValue.location
    ) {
      return null; // None of the specified fields have changed, exit
    }

    // Construct the notification payload
    const notificationTitle = `${newValue.title} @ ${newValue.society.name}`;
    const notificationText = 'Event details were changed';

    // Iterate through users in the "users" map and filter by "active" status
    const usersMap = newValue.registered_users || {};
    const activeUsers = Object.values(usersMap).filter((user) => user.active === true);

    // Extract FCM tokens from active users
    const fcmTokens = activeUsers.map((user) => user.fcm_token);

    const messaging = admin.messaging();
    const sendNotifications = fcmTokens.map(async (token) => {
      const payload = {
        notification: {
          title: notificationTitle,
          body: notificationText,
        },
      };

      try {
        await messaging.sendToDevice(token, payload);
        console.log('Notification sent to user with FCM token:', token);
      } catch (error) {
        console.error('Error sending notification:', error);
      }
    });

    // Wait for all notifications to be sent
    await Promise.all(sendNotifications);

    return null;
  });



 

  exports.sendPushNotificationOnMessageAdded = functions.firestore
  .document('/universities/university-of-warwick/chats/{chatId}')
  .onUpdate(async (change, context) => {
    const newValue = change.after.data(); // Updated document data
    const previousValue = change.before.data(); // Previous document data

    if (!newValue || !previousValue) {
      // Document data not available, exit
      return null;
    }

    // Check if a new message was added
    const newMessages = newValue.messages;
    const previousMessages = previousValue.messages;

    if (!newMessages || !previousMessages || newMessages.length <= previousMessages.length) {
      // No new message added or messages were deleted, exit
      return null;
    }

    // Iterate through users in the "users" map
    const usersMap = newValue.users || {};
    const fcmTokens = Object.values(usersMap).map((user) => user.fcm_token);

    // Construct the notification payload
    const newMessage = newMessages[newMessages.length - 1];
    let authorName = '';

    if (newMessage.author.path && newMessage.author.path.includes('societies')) {
      // Author is a society
      authorName = newValue.society.name;
    } else {
      // Author is a user
      const userId = newMessage.author.id;
      const userFullName = usersMap[userId] ? usersMap[userId].full_name : '';
      authorName = userFullName;
    }

    const payload = {
      notification: {
        title: `${newValue.type == "event_chat" ? `${newValue.event.title} @ ` :  `` }${newValue.society.name}`,
        body: `${authorName}: ${newMessage.content}`,
      },
    };

    // Send the notification to each user in the "users" map
    const messaging = admin.messaging();
    const sendNotifications = fcmTokens.map(async (token) => {
      try {
        await messaging.sendToDevice(token, payload);
        console.log('Notification sent to user with FCM token:', token);
      } catch (error) {
        console.error('Error sending notification:', error);
      }
    });

    // Wait for all notifications to be sent
    await Promise.all(sendNotifications);

    return null;
  });



    
  exports.updateChatsOnUserUpdate = functions.firestore
    .document('universities/university-of-warwick/users/{userId}')
    .onUpdate(async (change, context) => {
      const userId = context.params.userId;
      const newData = change.after.data();
      const previousData = change.before.data();
  
      // Check if relevant fields have changed
      const fieldsToCheck = ['full_name', 'username', 'fcm_token', 'image_url'];
      const hasFieldsChanged = fieldsToCheck.some(field => newData[field] !== previousData[field]);
  
      if (hasFieldsChanged) {
        const chatsRef = firestore.collection('universities/university-of-warwick/chats');
  
        // Query and update documents in the 'chats' collection
        const chatsQuery = await chatsRef.where(`users.${userId}.active`, 'in', [true, false]).get();
  
        const batch = firestore.batch();
  
        chatsQuery.forEach(doc => {
          const chatData = doc.data();
          chatData.users[userId].full_name = newData.full_name;
          chatData.users[userId].username = newData.username;
          chatData.users[userId].fcm_token = newData.fcm_token;
          chatData.users[userId].image_url = newData.image_url;
  
          batch.update(doc.ref, chatData);
        });
  
        // Commit the batch update
        return batch.commit();
      }
  
      return null; // No changes in relevant fields
    });
    
    exports.updateEventsOnUserUpdate = functions.firestore
    .document('universities/university-of-warwick/registered_users/{userId}')
    .onUpdate(async (change, context) => {
      const userId = context.params.userId;
      const newData = change.after.data();
      const previousData = change.before.data();
  
      // Check if relevant fields have changed
      const fieldsToCheck = ['full_name', 'username', 'fcm_token', 'image_url'];
      const hasFieldsChanged = fieldsToCheck.some(field => newData[field] !== previousData[field]);
  
      if (hasFieldsChanged) {
        const eventsRef = firestore.collection('universities/university-of-warwick/events');
  
        // Query and update documents in the 'events' collection for both 'true' and 'false'
        const eventsQuery = await eventsRef.where(`registered_users.${userId}.active`, 'in', [true, false]).get();
  
        const batch = firestore.batch();
  
        eventsQuery.forEach(doc => {
          const eventData = doc.data();
          eventData.registered_users[userId].full_name = newData.full_name;
          eventData.registered_users[userId].username = newData.username;
          eventData.registered_users[userId].fcm_token = newData.fcm_token;
          eventData.registered_users[userId].image_url = newData.image_url;
  
          batch.update(doc.ref, eventData);
        });
  
        // Commit the batch update
        return batch.commit();
      }
  
      return null; // No changes in relevant fields
    });
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
