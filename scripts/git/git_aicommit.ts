/**
 * This script enables the git aicommit command which is sourced in my .gitconfig
 *
 * What it does:
 * - reads `git diff --staged` to get changed files ready for commiting
 * - passes that plus a pre-baked prompt as context to a local llm api at the /generate endpoint
 * - llm returns a commit message
 * - script asks for confirmation before proceeding with running `git commit -m '[generated msg]'`
 *
 * Usage:
 * - git aicommit
 */

import { $ } from "bun";
import process from "process";

async function tryCatch(cb: Function): Promise<any> {
  try {
    const res = await cb();
    return [null, res];
  } catch (e) {
    return [new Error("There was an error"), null];
  }
}

async function getCommitMsg(diff: string): Promise<string> {
  const prompt = `Generate a concise conventional commit message based on the following git diff.
      Use one of these types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert.
      Format: <type>(<optional scope>): <description>
      For example:
      - feat(ui): add login button
      - fix(api): correct user authentication bug
      - refactor: simplify conditional logic in parser
      Here's the git diff:
      ${diff}`;
  const model = "qwen2.5-coder:7b";
  const data = {
    model,
    prompt,
    stream: false,
  };

  return $`curl http://localhost:11434/api/generate -d '${JSON.stringify(data)}'`.text();
}

async function main(): Promise<void> {
  const diff = await $`git diff --staged`.text(); // Hello World!
  const [err, msg] = await tryCatch(() => getCommitMsg(diff));

  if (err) {
    console.error(err);
    process.exit(1);
  }

  const res = JSON.parse(msg);
  await $`echo "${res.response}"`;
  process.exit(1);
}

main();
