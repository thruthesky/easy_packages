import { FieldValue } from "firebase/firestore";

interface ChatRoom {
  id?: string;
  name?: string;
  description?: string;
  // This will include the readings and order
  users?: { [key: string]: ChatUser };
  invitedUsers?: string[] | FieldValue;
  rejectedUsers?: string[];
  blockedUsers?: string[];
  masterUsers?: string[];
  hasPassword?: boolean;
  open?: boolean;
  single?: boolean;
  group?: boolean;
  iconUrl?: string;
  creator?: string;
  masterUids?: string[];
  lastMessageId?: string;
  lastMessageText?: string;
  lastMessageUrl?: number;
  lastMessageUid?: string;
  lastMessageDeleted?: boolean;
  verifiedUserOnly?: boolean;
  urlForVerifiedUserOnly?: string;
  uploadForVerifiedUserOnly?: string;
  gender?: string;
  domain?: string;
}

interface ChatUser {
  // Single Order is the single order that is affected by read
  sO?: any;
  // Single Time Order is the single order that is only determined when the message was sent
  sTO?: any;
  // Group Order is the group order that is affected by read
  gO?: any;
  // Group Time Order is the group order that is only determined when the message was sent
  gTO?: any;
  // Order is the order that is affected by read wheter it is single or group
  o?: any;
  // Time Order is the order that is only determined when the message was sent
  tO?: any;
  // New Message Counter is the number of new message
  nMC?: any;
}

export { ChatRoom, ChatUser };
