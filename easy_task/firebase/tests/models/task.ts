export const taskCol = "/task";

export function randomTaskId() {
  return Date.now().toString() + Math.ceil(Math.random() * 1000000);
}

export function taskRef(id?: string) {
  if (id) {
    return `${taskCol}/${id}`;
  }
  return `${taskCol}/${randomTaskId()}`;
}

export type Task = {
  title?: string;
  description?: string;
  creator?: string;
  parent?: string;
  child?: string;
  childCount?: number;
  completedChildCount?: number;
  project?: string;
  urls?: string[];
};
