import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.2.7/base/config.ts";
import {
  ActionFlags,
  BaseConfig,
} from "https://deno.land/x/ddu_vim@v3.2.7/types.ts";
import { Params as FfParams } from "https://deno.land/x/ddu_ui_ff@v1.0.2/ff.ts";
import { ActionData as GitStatusActionData } from "https://raw.githubusercontent.com/kuuote/ddu-source-git_status/b7e491760203d390404166af52d84939b68f51f9/denops/%40ddu-kinds/git_status.ts";

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.patchGlobal({
      ui: "ff",
      uiParams: {
        ff: {
          startFilter: true,
          prompt: "> ",
          split: "floating",
          floatingBorder: "single",
          filterSplitDirection: "floating",
          filterFloatingPosition: "top",
          previewFloating: true,
          previewFloatingBorder: "single",
          previewFloatingTitle: "Preview",
          highlights: {
            floating: "Normal",
            floatingBorder: "Normal",
          },
          autoAction: {
            name: "preview",
          },
        } satisfies Partial<FfParams>,
      },
      sourceOptions: {
        _: {
          matchers: ["matcher_fzf"],
          sorters: ["sorter_fzf"],
          converters: ["converter_devicon"],
        },
        help: {
          converters: [],
        },
        rg: {
          matchers: [],
          sorters: [],
          converters: ["converter_hl_dir"],
          volatile: true,
        },
        line: {
          matchers: ["matcher_substring"],
          sorters: [],
          converters: [],
        },
        dein: {
          defaultAction: "openProject",
        },
        ghq: {
          defaultAction: "openProject",
        },
        file_external: {
          converters: ["converter_hl_dir", "converter_devicon"],
        },
        deno_module: {
          volatile: true,
          columns: ["filename"],
        },
        git_status: {
          converters: [
            "converter_devicon",
            "converter_hl_dir",
            "converter_git_status",
          ],
        },
      },
      kindOptions: {
        file: {
          defaultAction: "open",
        },
        help: {
          defaultAction: "open",
        },
        lsp: {
          defaultAction: "open",
        },
        lsp_codeAction: {
          defaultAction: "apply",
        },
        ui_select: {
          defaultAction: "select",
        },
        action: {
          defaultAction: "do",
        },
        deno_module: {
          defaultAction: "resolve",
        },
        git_status: {
          defaultAction: "open",
          actions: {
            chaperon: async (args) => {
              const { denops, items } = args;
              for (const item of items) {
                const action = item.action as GitStatusActionData;
                await denops.cmd(`GinChaperon ${action.path}`);
              }
              return ActionFlags.None;
            },
            patch: async (args) => {
              const { denops, items } = args;
              for (const item of items) {
                const action = item.action as GitStatusActionData;
                await denops.cmd(`GinPatch ${action.path}`);
              }
              return ActionFlags.None;
            },
          },
        },
      },
      kindParams: {
        file: {
          trashCommand: ["trash"],
        },
      },
      filterParams: {
        matcher_fzf: {
          highlightMatched: "Search",
        },
        matcher_substring: {
          highlightMatched: "Search",
        },
        converter_hl_dir: {
          hlGroup: "String",
        },
      },
      sourceParams: {
        file_external: {
          cmd: ["fd", "-t", "file"],
        },
        buffer: {
          orderby: "asc",
        },
        lsp_references: {
          includeDeclaration: false,
        },
      },
    });

    return Promise.resolve();
  }
}
