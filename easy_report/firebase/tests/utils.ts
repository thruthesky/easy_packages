// import { assertFails, assertSucceeds } from '@firebase/rules-unit-testing';




// export async function expectDatabasePermissionDenied(promise: Promise<any>) {
//     const errorResult = await assertFails(promise);
//     expect(errorResult.code).toBe('PERMISSION_DENIED');
// }


// export async function expectPermissionGetSucceeds(promise: Promise<any>) {
//     expect(assertSucceeds(promise)).not.toBeUndefined();
// }

// export async function expectDatabasePermissionUpdateSucceeds(promise: Promise<any>) {
//     const successResult = await assertSucceeds(promise);
//     expect(successResult).toBeUndefined();
// }