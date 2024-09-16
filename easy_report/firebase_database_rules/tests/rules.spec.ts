import {
    RulesTestEnvironment,
    assertSucceeds,
    initializeTestEnvironment
} from "@firebase/rules-unit-testing";
import { assert } from "console";
import { ref, get, orderByChild, equalTo, query, update, DataSnapshot } from 'firebase/database';
import { readFileSync } from "fs";
import { before } from "mocha";



/****** SETUP ********/
const PROJECT_ID = 'fakeproject2';
const host = '127.0.0.1'; // Do not use localhost.
// Set this to the appropriate port displayed in the terminal when you run the Emulators.
// Example: Database │ 127.0.0.1: 9000
const port = 9000;
let testEnv: RulesTestEnvironment;



describe('Overall Rules Test', async () => {
    // Initialize the test environment once on every run.
    before(async () => {
        /// Initialize the test environment before running all tests.
        testEnv = await initializeTestEnvironment({
            projectId: PROJECT_ID,
            database: {
                host,
                port,
                // Read the Database Security Rules file once every run.
                rules: readFileSync('database.rules.json', 'utf8'),
            },
        });

    });

    // Clear all data in the local Firestore before each test.
    beforeEach(async () => {
        await testEnv.clearDatabase();
        await testEnv.withSecurityRulesDisabled(async (context) => {
            await context.database().ref('test/a').set({ name: 'apple', no: 1 });
        });
    });


    it('Create a report', async () => {
        const authedDb = testEnv.authenticatedContext('user1').database();
        await assertSucceeds(update(ref(authedDb, 'reports/report-1'), { reporter: 'user1' }));
    });

    it('Get the list of my reports', async () => {
        await testEnv.withSecurityRulesDisabled(async (context) => {
            await context.database().ref('reports/report-1').set({ reporter: 'user1', data: 'data1' });
        });
        await testEnv.withSecurityRulesDisabled(async (context) => {
            await context.database().ref('reports/report-2').set({ reporter: 'user1', data: 'data2' });
        });
        await testEnv.withSecurityRulesDisabled(async (context) => {
            await context.database().ref('reports/report-3').set({ reporter: 'user3', data: 'data3' });
        });
        const authedDb = testEnv.authenticatedContext('user1').database();
        const reportsQuery = query(ref(authedDb, 'reports'), orderByChild('reporter'), equalTo('user1'));
        await assertSucceeds(get(reportsQuery));

        const snapshot: DataSnapshot = await get(reportsQuery);
        const reports = snapshot.val();
        assert(Object.keys(reports).length == 2);
    });
});
