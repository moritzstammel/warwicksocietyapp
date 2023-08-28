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




// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
