import {
  RulesTestEnvironment,
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from "@firebase/rules-unit-testing";
import firebase from "firebase/compat/app";
import {
  doc,
  getDoc,
  setDoc,
  updateDoc,
  deleteDoc,
  setLogLevel,
  Firestore,
  FieldValue,
  arrayRemove,
  arrayUnion,
} from "firebase/firestore";
import { readFileSync } from "node:fs";
import { before } from "mocha";
import { chatRoomRef, generateRandomId, getRoomPath } from "./functions";
import { ChatRoom, ChatUser } from "./models/chat_room";

/****** SETUP ********/
const PROJECT_ID = "withcenter-test-5";
const host = "127.0.0.1";
const port = 8080;
let testEnv: RulesTestEnvironment;

const appleId = "apple";
const bananaId = "banana";
const carrotId = "carrot";
const durianId = "durian";
const eggPlantId = "eggPlant";
const flowerId = "flower";
const guavaId = "guava";

let unauthedDb: firebase.firestore.Firestore;
let appleDb: firebase.firestore.Firestore;
let bananaDb: firebase.firestore.Firestore;
let carrotDb: firebase.firestore.Firestore;
let durianDb: firebase.firestore.Firestore;
let eggPlantDb: firebase.firestore.Firestore;
let flowerDb: firebase.firestore.Firestore;
let guavaDb: firebase.firestore.Firestore;

async function clearAndResetFirestoreContext(): Promise<void> {
  await testEnv.clearFirestore();
  unauthedDb = testEnv.unauthenticatedContext().firestore();
  appleDb = testEnv.authenticatedContext(appleId).firestore();
  bananaDb = testEnv.authenticatedContext(bananaId).firestore();
  carrotDb = testEnv.authenticatedContext(carrotId).firestore();
  durianDb = testEnv.authenticatedContext(durianId).firestore();
  eggPlantDb = testEnv.authenticatedContext(eggPlantId).firestore();
  flowerDb = testEnv.authenticatedContext(flowerId).firestore();
  guavaDb = testEnv.authenticatedContext(guavaId).firestore();
}

describe("Chat Room Creation Test", async () => {
  before(async () => {
    setLogLevel("error");
    testEnv = await initializeTestEnvironment({
      projectId: PROJECT_ID,
      firestore: {
        host,
        port,
        rules: readFileSync("firestore.rules", "utf8"),
      },
    });
  });
  beforeEach(async () => {
    await clearAndResetFirestoreContext();
  });

  it("[Pass] Create Room with name as creator, master, and member (1)", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      creator: appleId,
      masterUids: [appleId],
      users: {
        [appleId]: {
          nMC: 0,
        },
      },
    };
    await assertSucceeds(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Pass] Create Room with name as creator, master, and member (2)", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      group: true,
      creator: appleId,
      masterUids: [appleId],
      users: {
        [appleId]: {
          nMC: 0,
        },
      },
    };
    await assertSucceeds(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Pass] Create Open Group Chat", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      group: true,
      open: true,
      creator: appleId,
      masterUids: [appleId],
      users: {
        [appleId]: {
          nMC: 0,
        },
      },
    };
    await assertSucceeds(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Pass] Create Room as creator, master, and member without name", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      creator: appleId,
      masterUids: [appleId],
      users: {
        [appleId]: {
          nMC: 0,
        },
      },
    };
    await assertSucceeds(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Fail] Create Room with name and description but no creator", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      masterUids: [appleId],
      users: {
        [appleId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Fail] Create Room with name and description but no masterUid", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      creator: appleId,
      users: {
        [appleId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Fail] Create Room with name and description but no member", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      creator: appleId,
      masterUids: [appleId],
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Fail] Create Room with name and description but no member and creator", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      masterUids: [appleId],
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Fail] Create Room with name and description but no master and creator", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      users: {
        [appleId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Fail] Create Room with name and description but no member and master", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      creator: appleId,
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Fail] Create Room with Extra User as member", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      creator: appleId,
      masterUids: [appleId],
      users: {
        [appleId]: {
          nMC: 0,
        },
        [bananaId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Fail] Create Room with Extra User as master (1)", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      creator: appleId,
      masterUids: [appleId, bananaId],
      users: {
        [appleId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Fail] Create Room with Extra User as master (2)", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      creator: appleId,
      masterUids: [appleId, bananaId],
      users: {
        [appleId]: {
          nMC: 0,
        },
        [bananaId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Fail] Create Room but creator, member, and master is a different user", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      creator: appleId,
      masterUids: [appleId],
      users: {
        [appleId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(bananaDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Fail] Create Room but creator is a different user", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      creator: appleId,
      masterUids: [bananaId],
      users: {
        [bananaId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(bananaDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Fail] Create Room but master is a different user", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      creator: bananaId,
      masterUids: [appleId],
      users: {
        [bananaId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(bananaDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Fail] Create Room but users is a different user", async () => {
    const appleGroup: ChatRoom = {
      name: "apple group",
      creator: bananaId,
      masterUids: [bananaId],
      users: {
        [appleId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(bananaDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Pass] Create Single Room", async () => {
    const appleGroup: ChatRoom = {
      name: "apple and banana",
      single: true,
      creator: appleId,
      masterUids: [appleId],
      users: {
        [appleId]: {
          nMC: 0,
        },
      },
    };
    await assertSucceeds(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleGroup)
    );
  });
  it("[Pass] Create Single Room with 1 invitation", async () => {
    const appleAndBananaRoom: ChatRoom = {
      name: "apple and banana",
      single: true,
      creator: appleId,
      masterUids: [appleId],
      users: {
        [appleId]: {
          nMC: 0,
        },
      },
      invitedUsers: [bananaId],
    };
    await assertSucceeds(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleAndBananaRoom)
    );
  });
  it("[Fail] Create Single Room with 2 invitations", async () => {
    const appleAndBananaRoom: ChatRoom = {
      name: "apple and banana",
      single: true,
      creator: appleId,
      masterUids: [appleId],
      users: {
        [appleId]: {
          nMC: 0,
        },
      },
      invitedUsers: [bananaId, carrotId],
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleAndBananaRoom)
    );
  });
  it("[Fail] Create Single Room with 3 invitations", async () => {
    const appleAndBananaRoom: ChatRoom = {
      name: "apple and banana",
      single: true,
      creator: appleId,
      masterUids: [appleId],
      users: {
        [appleId]: {
          nMC: 0,
        },
      },
      invitedUsers: [bananaId, carrotId, durianId],
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleAndBananaRoom)
    );
  });
  it("[Fail] Create Single Room but I am the invited", async () => {
    const appleAndBananaRoom: ChatRoom = {
      name: "apple and banana",
      single: true,
      creator: bananaId,
      masterUids: [bananaId],
      users: {
        [bananaId]: {
          nMC: 0,
        },
      },
      invitedUsers: [appleId],
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleAndBananaRoom)
    );
  });
  it("[Fail] Create Single Room but I invited myself and another", async () => {
    const appleAndBananaRoom: ChatRoom = {
      name: "apple and banana",
      single: true,
      creator: appleId,
      masterUids: [appleId],
      users: {
        [appleId]: {
          nMC: 0,
        },
      },
      invitedUsers: [appleId, bananaId],
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(generateRandomId())), appleAndBananaRoom)
    );
  });
});

describe("Group Chat Room Update Test", async () => {
  const appleGroup: ChatRoom = {
    name: "apple group",
    creator: appleId,
    masterUids: [appleId, bananaId],
    users: {
      [appleId]: {
        nMC: 0,
      },
      [bananaId]: {
        nMC: 0,
      },
      [carrotId]: {
        nMC: 0,
      },
    },
  };
  let appleGroupId: string = "apple-group-id";
  before(async () => {
    setLogLevel("error");
    testEnv = await initializeTestEnvironment({
      projectId: PROJECT_ID,
      firestore: {
        host,
        port,
        rules: readFileSync("firestore.rules", "utf8"),
      },
    });
  });
  beforeEach(async () => {
    await clearAndResetFirestoreContext();

    // Create the apple's group for each test
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(
        doc(context.firestore(), getRoomPath(appleGroupId)),
        appleGroup
      );
    });
  });
  // TODO only creator or master can update the Name, Description
  //   it("[Pass] Update Room Name as Creator", async () => {
  //     const appleGroupUpdate: ChatRoom = {
  //       name: "apple group better name",
  //     };
  //     await assertSucceeds(
  //       setDoc(doc(appleDb, chatRoomRef + "/" + appleGroupId), appleGroupUpdate, {
  //         merge: true,
  //       })
  //     );
  //   });
  it("[Pass] Creator invited a user", async () => {
    const appleGroupUpdate: ChatRoom = {
      invitedUsers: [eggPlantId],
    };

    await assertSucceeds(
      setDoc(doc(appleDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Pass] Master invited a user", async () => {
    const appleGroupUpdate: ChatRoom = {
      invitedUsers: [eggPlantId],
    };

    await assertSucceeds(
      setDoc(doc(bananaDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Member invited a user", async () => {
    const appleGroupUpdate: ChatRoom = {
      invitedUsers: [eggPlantId],
    };
    await assertFails(
      setDoc(doc(carrotDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Member invited a user", async () => {
    const appleGroupUpdate: ChatRoom = {
      invitedUsers: [eggPlantId],
    };
    await assertFails(
      setDoc(doc(carrotDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Outsider invited a user", async () => {
    const appleGroupUpdate: ChatRoom = {
      invitedUsers: [flowerId],
    };
    await assertFails(
      setDoc(doc(eggPlantDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Outsider invited himself", async () => {
    const appleGroupUpdate: ChatRoom = {
      invitedUsers: [eggPlantId],
    };
    await assertFails(
      setDoc(doc(eggPlantDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Joining to a non-open Group Chat", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [eggPlantId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(eggPlantDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
});

describe("Open Group Chat Room Joining Test (Open: True)", async () => {
  const appleGroup: ChatRoom = {
    name: "apple group",
    creator: appleId,
    group: true,
    open: true,
    masterUids: [appleId, bananaId],
    users: {
      [appleId]: {
        nMC: 0,
      },
      [bananaId]: {
        nMC: 0,
      },
      [carrotId]: {
        nMC: 0,
      },
    },
    invitedUsers: [eggPlantId],
  };
  let appleGroupId: string = "apple-group-id";
  before(async () => {
    setLogLevel("error");
    testEnv = await initializeTestEnvironment({
      projectId: PROJECT_ID,
      firestore: {
        host,
        port,
        rules: readFileSync("firestore.rules", "utf8"),
      },
    });
  });
  beforeEach(async () => {
    await clearAndResetFirestoreContext();
    // Create the apple's group for each test
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(
        doc(context.firestore(), getRoomPath(appleGroupId)),
        appleGroup
      );
    });
  });
  it("[Pass] Joining to an Open Group Chat, Not Invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [flowerId]: {
          nMC: 0,
        },
      },
    };
    await assertSucceeds(
      setDoc(doc(flowerDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Pass] Joining to an Open Group Chat, Invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [eggPlantId]: {
          nMC: 0,
        },
      },
    };
    await assertSucceeds(
      setDoc(doc(eggPlantDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Creator put another user who is not invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [flowerId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Creator put another user who is invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [eggPlantId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Master put another user who is not invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [flowerId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(bananaDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Master put another user who is invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [eggPlantId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(bananaDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Member put another user who is not invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [flowerId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(carrotDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Member put another user who is invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [eggPlantId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(carrotDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
});

describe("Non-open Group Chat Room Joining Test (Open: Null)", async () => {
  const appleGroup: ChatRoom = {
    name: "apple group",
    creator: appleId,
    // open: false
    group: true,
    masterUids: [appleId, bananaId],
    users: {
      [appleId]: {
        nMC: 0,
      },
      [bananaId]: {
        nMC: 0,
      },
      [carrotId]: {
        nMC: 0,
      },
    },
    invitedUsers: [eggPlantId],
  };
  let appleGroupId: string = "apple-group-id";
  before(async () => {
    setLogLevel("error");
    testEnv = await initializeTestEnvironment({
      projectId: PROJECT_ID,
      firestore: {
        host,
        port,
        rules: readFileSync("firestore.rules", "utf8"),
      },
    });
  });
  beforeEach(async () => {
    await clearAndResetFirestoreContext();
    // Create the apple's group for each test
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(
        doc(context.firestore(), getRoomPath(appleGroupId)),
        appleGroup
      );
    });
  });
  it("[Pass] Joining to an Non-Open Group Chat, Invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [eggPlantId]: {
          nMC: 0,
        },
      },
      invitedUsers: arrayRemove(eggPlantId),
    };
    await assertSucceeds(
      setDoc(doc(eggPlantDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Joining to an Non-Open Group Chat, Not Invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [flowerId]: {
          nMC: 0,
        },
      },
      invitedUsers: arrayRemove(flowerId),
    };
    await assertFails(
      setDoc(doc(flowerDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Creator put another user who is not invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [flowerId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Creator put another user who is invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [eggPlantId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Master put another user who is not invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [flowerId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(bananaDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Master put another user who is invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [eggPlantId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(bananaDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Member put another user who is not invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [flowerId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(carrotDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Member put another user who is invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [eggPlantId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(carrotDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
});

describe("Non-open Group Chat Room Joining Test (Open: False)", async () => {
  const appleGroup: ChatRoom = {
    name: "apple group",
    creator: appleId,
    open: false,
    group: true,
    masterUids: [appleId, bananaId],
    users: {
      [appleId]: {
        nMC: 0,
      },
      [bananaId]: {
        nMC: 0,
      },
      [carrotId]: {
        nMC: 0,
      },
    },
    invitedUsers: [eggPlantId],
  };
  let appleGroupId: string = "apple-group-id";
  before(async () => {
    setLogLevel("error");
    testEnv = await initializeTestEnvironment({
      projectId: PROJECT_ID,
      firestore: {
        host,
        port,
        rules: readFileSync("firestore.rules", "utf8"),
      },
    });
  });
  beforeEach(async () => {
    await clearAndResetFirestoreContext();
    // Create the apple's group for each test
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(
        doc(context.firestore(), getRoomPath(appleGroupId)),
        appleGroup
      );
    });
  });
  it("[Pass] Joining to an Non-Open Group Chat, Invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [eggPlantId]: {
          nMC: 0,
        },
      },
      invitedUsers: arrayRemove(eggPlantId),
    };
    await assertSucceeds(
      setDoc(doc(eggPlantDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Joining to an Non-Open Group Chat, Not Invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [flowerId]: {
          nMC: 0,
        },
      },
      invitedUsers: arrayRemove(flowerId),
    };
    await assertFails(
      setDoc(doc(flowerDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Creator put another user who is not invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [flowerId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Creator put another user who is invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [eggPlantId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Master put another user who is not invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [flowerId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(bananaDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Master put another user who is invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [eggPlantId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(bananaDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Member put another user who is not invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [flowerId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(carrotDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Member put another user who is invited", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [eggPlantId]: {
          nMC: 0,
        },
      },
    };
    await assertFails(
      setDoc(doc(carrotDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
});

describe("Single Chat Room Join Test", async () => {
  const appleGroup: ChatRoom = {
    name: "apple and banana",
    creator: appleId,
    single: true,
    masterUids: [appleId, bananaId],
    users: {
      [appleId]: {
        nMC: 0,
      },
      //   [bananaId]: {
      //     nMC: 0,
      //   },
    },
    invitedUsers: [bananaId],
  };
  let appleGroupId: string = "apple-banana-id";
  before(async () => {
    setLogLevel("error");
    testEnv = await initializeTestEnvironment({
      projectId: PROJECT_ID,
      firestore: {
        host,
        port,
        rules: readFileSync("firestore.rules", "utf8"),
      },
    });
  });

  beforeEach(async () => {
    await clearAndResetFirestoreContext();
    // Create the apple's group for each test
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(
        doc(context.firestore(), getRoomPath(appleGroupId)),
        appleGroup
      );
    });
  });

  it("[Fail] Outsider Joining to a Single Chat", async () => {
    const appleGroupUpdate: ChatRoom = {
      users: {
        [eggPlantId]: {
          nMC: 0,
        },
      },
      invitedUsers: arrayRemove(eggPlantId),
    };
    await assertFails(
      setDoc(doc(eggPlantDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
  it("[Fail] Creator invited a user to a Single Chat", async () => {
    const appleGroupUpdate: ChatRoom = {
      invitedUsers: arrayUnion(eggPlantId),
    };
    await assertFails(
      setDoc(doc(appleDb, getRoomPath(appleGroupId)), appleGroupUpdate, {
        merge: true,
      })
    );
  });
});
