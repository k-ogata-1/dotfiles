import { Denops, fn } from "../../../deps.ts";
import { currentWorktree } from "../util.ts";
import { Command } from "./main.ts";

export const command: Command = {
  name: "rg",
  exec: async (denops: Denops) => {
    return {
      resume: false,
      sources: [
        {
          name: "rg",
          options: {
            path: await currentWorktree(denops) ?? await fn.getcwd(denops),
          },
        },
      ],
    };
  },
};