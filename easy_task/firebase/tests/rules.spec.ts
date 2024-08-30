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
  deleteField,
  increment,
} from "firebase/firestore";
import { readFileSync } from "node:fs";
import { before } from "mocha";
// import { chatRoomRef, generateRandomId, getRoomPath } from "./functions";

/****** SETUP ********/
const PROJECT_ID = "withcenter-test-3";
const host = "127.0.0.1";
const port = 8080;
let testEnv: RulesTestEnvironment;

const beforeSetup = async () => {
  setLogLevel("error");
  testEnv = await initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: {
      host,
      port,
      rules: readFileSync("firestore.rules", "utf8"),
    },
  });
};

const beforeEachSetup = async () => {};

describe("Task user group crud test", async () => {
  before(beforeSetup);
  beforeEach(beforeEachSetup);
});
