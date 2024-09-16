import {
    RulesTestEnvironment,
    assertFails,
    assertSucceeds,
    initializeTestEnvironment
} from "@firebase/rules-unit-testing";
import firebase from 'firebase/compat/app';
import { ref, get, update } from 'firebase/database';
import { readFileSync } from "node:fs";
import { before } from "mocha";
import { assert } from "node:console";



/****** SETUP ********/
const PROJECT_ID = 'fakeproject2';
const host = '127.0.0.1'; // localhost 로 하면 안된다.
// 터미널에 표시되는 포트로 적절히 지정해야 한다. Emulators 를 실행하면, 터미날에 아래와 같이 포트가 DB 포트가 표시된다.
// 예) Database │ 127.0.0.1: 9000
const port = 9000;
let testEnv: RulesTestEnvironment;



describe('전반적인 규칙 테스트', async () => {
    // 모든 테스트를 시작하기 전에 실행되는 콜백 함수.
    // 여기에 initializeTestEnvironment() 를 호출해서, 테스트 환경을 초기화 하면 된다.
    // Firestore, Realtime Database, Storage 등을 모두 같이 쓰는 코드이다.
    before(async () => {
        /// 모든 테스트를 실행하기 전에, 테스트 환경 초기화.
        testEnv = await initializeTestEnvironment({
            projectId: PROJECT_ID,
            database: {
                host,
                port,
                // Firestore Security Rules 파일을 읽어서, 테스트 환경에 적용한다.
                // 즉, Security Rules 파일을 수정하고, 테스트를 다시 실행하면, 수정된 Rules 이 적용되므로,
                // mocha watch 를 하는 경우, 소스 코드를 수정 필요 없이 저장만 한번 해 주면 된다.
                rules: readFileSync('database.rules.json', 'utf8')
            },
        });

    });

    // 각 테스트를 하기 전에, 로컬 Firestore 의 데이터를 모두 지운다.
    beforeEach(async () => {
        await testEnv.clearDatabase();

        // 셋업: Security Rules 를 적용하지 않고, 테스트 데이터를 미리 좀 저장해 놓는다.
        // withSecurityRulesDisabled 는 한번에 하나의 쿼리만 실행해야 한다. 그렇지 않으면,
        // xxxx has already been started and its settings can no longer be change 에러가 발생한다.
        await testEnv.withSecurityRulesDisabled(async (context) => {
            await context.database().ref('test/a').set({ name: 'apple', no: 1 });
        });

    });

    it('공개 프로필 읽기 테스트 - 성공 - 로그인 하지 않고 참조', async () => {
        // Setup: Create Rules Test Context
        const unauthedDb = testEnv.unauthenticatedContext().database();
        // const snapshot = await get(ref(unauthedDb, 'users/foobar'));

        await assertFails(get(ref(unauthedDb, 'users/foobar')));
    });
});


