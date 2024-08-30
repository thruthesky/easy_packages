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
  //   updateDoc,
  setLogLevel,
  //   arrayUnion,
  //   arrayRemove,
} from "firebase/firestore";
import { readFileSync } from "node:fs";
import {
  before,
  //  test
} from "mocha";
import {
  taskRef,
  Task,
  // randomTaskId
} from "./models/task";

/****** SETUP ********/
const PROJECT_ID = "withcenter-test-3"; // Set your firebase project ID here
const host = "127.0.0.1"; // Don't user "localhost" unless you have a reasion.
const port = 8080; // 터미날에 표시되는 포트로 적절히 지정해야 한다.
/****** UNTIL HERE */

let testEnv: RulesTestEnvironment;

// 로그인 하지 않은, unauthenticated context 를 글로벌에 저장해서, 타이핑을 줄이고 간소화 한다.
let unauthedDb: firebase.firestore.Firestore;

// 각 사용자별 로그인 context 를 저장해 놓고 편하게 사용한다.
let appleDb: firebase.firestore.Firestore;
let bananaDb: firebase.firestore.Firestore;
let cherryDb: firebase.firestore.Firestore;
let durianDb: firebase.firestore.Firestore;

describe("Task and Task Group Test", async () => {
  // 모든 테스트를 시작하기 전에 실행되는 콜백 함수.
  // 여기에 initializeTestEnvironment() 를 호출해서, Firestore 접속을 초기화 하면 된다.
  // watch 코드가 수정될 경우, 전체 테스트를 다시 실행하면, 이 함수도 다시 호출 된다.
  before(async () => {
    setLogLevel("error"); // 로그 레벨을 설정한다.
    /// 모든 테스트를 실행하기 전에, 파이어베이스 접속 초기화.
    testEnv = await initializeTestEnvironment({
      projectId: PROJECT_ID,
      firestore: {
        host,
        port,
        // Firestore Security Rules 파일을 읽어서, 테스트 환경에 적용한다.
        // 즉, Security Rules 파일을 수정하고, 테스트를 다시 실행하면, 수정된 Rules 이 적용되므로,
        // mocha watch 를 하는 경우, 소스 코드를 수정 필요 없이 저장만 한번 해 주면 된다.
        rules: readFileSync("firestore.rules", "utf8"),
      },
    });
  });

  // 각 테스트를 하기 전에, 로컬 Firestore 의 데이터를 모두 지운다.
  beforeEach(async () => {
    await testEnv.clearFirestore();

    // 셋업: Security Rules 를 적용하지 않고, 테스트 데이터를 미리 좀 저장해 놓는다.
    // withSecurityRulesDisabled 는 한번에 하나의 쿼리만 실행해야 한다. 그렇지 않으면,
    // Firestore has already been started and its settings can no longer be change 에러가 발생한다.
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await setDoc(doc(context.firestore(), "users/apple"), {
        name: "apple",
        no: 1,
      });
    });

    // 주의: 캐시 문제를 피하기 위해서, 각 테스트마다 새로운 unauthenticated context 로 DB 를 생성해야 한다.
    unauthedDb = testEnv.unauthenticatedContext().firestore();

    // 사용자별 DB 액세스 context 저장. 캐시 문제로 각 테스트 전에 새로 생성해야 한다.
    appleDb = testEnv.authenticatedContext("apple").firestore();
    bananaDb = testEnv.authenticatedContext("banana").firestore();
    cherryDb = testEnv.authenticatedContext("cherry").firestore();
    durianDb = testEnv.authenticatedContext("durian").firestore();
  });
  it("[Fail] User signed in anonymously and tried to read a task doc", async () => {
    await assertFails(getDoc(doc(unauthedDb, "/task/task1")));
  });
  it("[Fail] User signed in to read a task but wrong spelling of path (tasks instead of task)", async () => {
    await assertFails(getDoc(doc(appleDb, "/tasks/task1")));
  });
  it("[Pass] User signed in to read a task", async () => {
    await assertSucceeds(getDoc(doc(appleDb, "/task/task1")));
  });
  it("[Fail] User not signed in and tried to create a task", async () => {
    const taskCreateUnAuth: Task = {
      title: "Create Task Test",
      description: "Creating a task for testing",
      //   status: "open",
    };
    await assertFails(setDoc(doc(unauthedDb, taskRef()), taskCreateUnAuth));
  });
  it("[Pass] User signed in to create a task", async () => {
    const taskCreateApple: Task = {
      title: "Create Task Test",
      description: "Creating a task for testing",
      creator: "apple",
      //   status: "open",
    };
    await assertSucceeds(setDoc(doc(appleDb, taskRef()), taskCreateApple));
  });
  it("[Fail] Unauth user tried to make a task but in task, there is a creator", async () => {
    const taskCreateUnauthWithCreatedBy: Task = {
      title: "Create Task Test",
      description: "Creating a task for testing",
      creator: "apple",
      //   status: "open",
    };
    await assertFails(
      setDoc(doc(unauthedDb, taskRef()), taskCreateUnauthWithCreatedBy)
    );
  });
  it("[Fail] User used a different uid as the creator of the task upon creating it", async () => {
    const taskCreateAuthWithDifferentUid: Task = {
      title: "Create Task Test",
      description: "Creating a task for testing",
      creator: "IAmNotApple",
      //   status: "open",
    };
    await assertFails(
      setDoc(doc(appleDb, taskRef()), taskCreateAuthWithDifferentUid)
    );
  });
  it("[Pass] User created task and used his/her uid as the creator of the task", async () => {
    const taskCreateBanana: Task = {
      title: "Create Task Test",
      description: "Creating a task for testing",
      creator: "banana",
      //   status: "open",
    };
    await assertSucceeds(setDoc(doc(bananaDb, taskRef()), taskCreateBanana));
  });
});
