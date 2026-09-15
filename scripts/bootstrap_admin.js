const admin = require('firebase-admin');
const fs = require('fs');

// USAGE: node bootstrap_admin.js <path-to-serviceAccountKey.json> <admin-uid> <admin-email>

async function bootstrap() {
  if (process.argv.length < 5) {
    console.error("Usage: node bootstrap_admin.js <path-to-serviceAccountKey.json> <admin-uid> <admin-email>");
    process.exit(1);
  }

  const serviceAccountPath = process.argv[2];
  const uid = process.argv[3];
  const email = process.argv[4];

  if (!fs.existsSync(serviceAccountPath)) {
    console.error(`Error: Service account key file not found at ${serviceAccountPath}`);
    process.exit(1);
  }

  const serviceAccount = JSON.parse(fs.readFileSync(serviceAccountPath, 'utf8'));

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });

  const db = admin.firestore();
  const userRef = db.collection('users').doc(uid);

  const doc = await userRef.get();
  if (doc.exists) {
    console.log("Admin user document already exists. No action taken.");
    process.exit(0);
  }

  console.log(`Bootstrapping admin user for UID: ${uid}, Email: ${email}...`);

  await userRef.set({
    uid: uid,
    name: "Admin",
    email: email,
    role: "admin",
    isActive: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  });

  console.log("Successfully created admin profile in Firestore!");
}

bootstrap().catch((error) => {
  console.error("Error bootstrapping admin user:", error);
  process.exit(1);
});
