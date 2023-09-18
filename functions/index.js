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

exports.updateSpotlightsOnSocietyUpdate = functions.firestore
  .document('/universities/university-of-warwick/societies/{societyId}')
  .onUpdate(async (change, context) => {
    const updatedSocietyData = change.after.data();
    const newSocietyName = updatedSocietyData.name;
    const societyRef = change.after.ref;

    const spotlightsCollection = firestore.collection('/universities/university-of-warwick/spotlights');

    const snapshot = await spotlightsCollection
      .where('society_ref', '==', societyRef)
      .get();

    const batch = firestore.batch();

    snapshot.forEach((doc) => {
      const spotlightRef = doc.ref;
      batch.update(spotlightRef, { name: newSocietyName });
    });

    return batch.commit();
  });


  exports.updateChatsOnSocietyUpdate = functions.firestore
  .document('/universities/university-of-warwick/societies/{societyId}')
  .onUpdate(async (change, context) => {
    const updatedSocietyData = change.after.data();
    const updatedSocietyRef = change.after.ref;

    const updatedLogoUrl = updatedSocietyData.logo_url;
    const updatedSocietyName = updatedSocietyData.name;

    const chatsCollection = firestore.collection('/universities/university-of-warwick/chats');

    const snapshot = await chatsCollection
      .where('society.ref', '==', updatedSocietyRef)
      .get();

    const batch = firestore.batch();

    snapshot.forEach((doc) => {
      const chatRef = doc.ref;
      const chatData = doc.data();

      // Update society fields in chat
      batch.update(chatRef, {
        'society.logo_url': updatedLogoUrl,
        'society.name': updatedSocietyName
      });

      // Update author fields in messages
      const messages = chatData.messages || [];
      const updatedMessages = messages.map((message) => {
        if (message.author && message.author.ref.path === updatedSocietyRef.path) {
          return {
            ...message,
            author: {
              ...message.author,
              image_url: updatedLogoUrl,
              name: updatedSocietyName
            }
          };
        }
        return message;
      });

      batch.update(chatRef, { messages: updatedMessages });
    });

    batch.update(updatedSocietyRef, {
      logo_url: updatedLogoUrl,
      name: updatedSocietyName
    });

    return batch.commit();
  });


  exports.sendChatNotification = functions.firestore
  .document('/universities/university-of-warwick/users/{userId}')
  .onCreate(async(snapshot, context) => {
      
      // Get the FCM token of the recipient from your database
      const recipientToken = "eTYAvXyMTS-H-JEkvkEUPw:APA91bFN8WS__0YbBs3ZqxmyfTo0xZTwVeDl-9mYlbWj3d4nbb3gIsYAPSjzReLnJdJU6Z0qC9gG9kvnS8Ip2mW6BTAs8yDCHhocazL0zlbix3TlJnQwdYPnlhBA966XQQYypfrsaHKk";
      const payload = {
        notification: {
          title: "New Message",
          body: "You have a new message.",
        },
      };

      // Send the notification to the recipient
      return admin.messaging().sendToDevice(recipientToken, payload);
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

      const newMessage = newMessages[newMessages.length - 1]
      const payload = {
        notification: {
          title: newValue.society.name,
          body: newMessage.author.name + ": " + newMessage.content,
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

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
