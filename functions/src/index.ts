import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as nodemailer from "nodemailer";


admin.initializeApp();
const fcm = admin.messaging();

exports.checkHealth = functions.https.onCall(async (data, context) => {
  return "The function is online";
});

exports.sendNotification = functions.https.onCall(async (data, context) => {
  const title = data.title;
  const body = data.body;
  const image = data.image;
  const token = data.token;

  try {
    const payload = {
      token: token,
      notification: {
        title: title,
        body: body,
        image: image,
      },
      data: {
        body: body,
      },
    };

    return fcm.send(payload).then((response) => {
      return {success: true, response: "Succefully sent message: " + response};
    }).catch((error) => {
      return {error: error};
    });
  } catch (error) {
    throw new functions.https.HttpsError("invalid-argument", "error:" +error);
  }
});

exports.sendCustomVerificationEmail = functions.firestore
    .document('users/{userId}')
    .onCreate(async (snap, context) => {
        const userData = snap.data();
        const email = userData.email; // The email to send to
        const confirmationCode = userData.confirmationCode; // Your generated code

        // Configure nodemailer with your email service details
        const transporter = nodemailer.createTransport({
            service: 'gmail', // Example using Gmail
            auth: {
                user: 'your-email@gmail.com',
                pass: 'your-password'
            }
        });

        const mailOptions = {
            from: 'you@yourdomain.com',
            to: email,
            subject: 'Email Confirmation Code',
            text: `Your confirmation code is: ${confirmationCode}`
        };

        try {
            await transporter.sendMail(mailOptions);
            console.log('Email sent successfully');
        } catch (error) {
            console.error('Error sending email', error);
        }
    });

    exports.sendOrderNotification = functions.https.onCall((data, context) => {
      // Ensure that you check for authentication and authorization if necessary
  
      const payload = {
          notification: {
              title: 'New Order',
              body: `Order Details: ${data.orderDetails}, Address: ${data.address}, Note: ${data.note}, Total Price: ${data.totalPrice}`,
          },
          token: data.ownerToken,
      };
  
      return admin.messaging().send(payload)
          .then((response) => {
              return { success: true, messageId: response };
          })
          .catch((error) => {
              console.error('Error sending notification:', error);
              return { error: error };
          });
  });

  
  exports.notifyNewOrder = functions.firestore
      .document('orders/{orderId}')
      .onCreate(async (snapshot, context) => {
          // Get the new order data
          const newOrder = snapshot.data();
          if (!newOrder) return null; // Exit if no data
  
          // Retrieve the restaurant owner's FCM token
          // Assuming it's stored in Firestore under 'users/owner'
          const ownerRef = admin.firestore().doc('users/owner');
          const ownerDoc = await ownerRef.get();
          const ownerToken = ownerDoc.data()?.fcmToken;
          if (!ownerToken) {
              console.log('No owner token found');
              return null;
          }
  
          // Notification payload
          const payload = {
              notification: {
                  title: 'New Order Received',
                  body: `You have a new order from ${newOrder.customerName}. Total: ${newOrder.totalPrice}₺`
              },
              token: ownerToken,
          };
  
          // Send the notification
          try {
              const response = await admin.messaging().send(payload);
              console.log('Notification sent', response);
          } catch (error) {
              console.error('Error sending notification', error);
          }
  
          return null;
      });
  