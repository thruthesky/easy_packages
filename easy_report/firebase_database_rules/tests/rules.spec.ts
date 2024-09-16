import {
    RulesTestEnvironment,
    assertFails,
    assertSucceeds,
    initializeTestEnvironment
} from "@firebase/rules-unit-testing";
import firebase from 'firebase/compat/app';
import { ref, get, update, orderByChild, equalTo, query } from 'firebase/database';
import { readFileSync } from "node:fs";
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
                rules: JSON.stringify({
                    "rules": {
                        "users": {
                            ".read": true,
                            "$uid": {
                                ".write": "$uid === auth.uid"
                            },
                            ".indexOn": [
                                "createdAt"
                            ]
                        },
                        "reports": {
                            "$reportKey": {
                                ".read": "data.child('reporter').val() === auth.uid",
                                ".write": true
                            },
                            ".indexOn": [
                                "reporter",
                                "reportee",
                                "path"
                            ]
                        }
                    }
                }),
            },
        });

    });

    // Clear all data in the local Firestore before each test.
    beforeEach(async () => {
        await testEnv.clearDatabase();

        // Setup: some sample data by passing the security rules
        await testEnv.withSecurityRulesDisabled(async (context) => {
            await context.database().ref('test/a').set({ name: 'apple', no: 1 });
        });

    });

    it('Public Profile Read Test - Success - Reference without logging in', async () => {
        // Setup: Create Rules Test Context
        const unauthedDb = testEnv.unauthenticatedContext().database();
        await assertSucceeds(get(ref(unauthedDb, 'users/foobar')));
    });

    it('Get my report', async () => {
        await testEnv.withSecurityRulesDisabled(async (context) => {
            await context.database().ref('reports/report-1').set({ reporter: 'user1' });
        });
        const authedDb = testEnv.authenticatedContext('user1').database();
        await assertSucceeds(get(ref(authedDb, 'reports/report-1')));
    });

    it('Get the list of my reports', async () => {
        await testEnv.withSecurityRulesDisabled(async (context) => {
            await context.database().ref('reports/report-1').set({ reporter: 'user1' });
        });
        const authedDb = testEnv.authenticatedContext('user1').database();
        const reportsQuery = query(ref(authedDb, 'reports'), orderByChild('reporter'), equalTo('user1'));
        await assertSucceeds(get(reportsQuery));
    });
});