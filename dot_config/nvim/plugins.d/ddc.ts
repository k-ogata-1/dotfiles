import { ConfigArguments } from "https://deno.land/x/ddc_vim@v4.0.4/base/config.ts";
import {
  BaseConfig,
  UserSource,
} from "https://deno.land/x/ddc_vim@v4.0.4/types.ts";

const generalSources: UserSource[] = [
  {
    name: "skkeleton",
    options: {
      mark: "[SKK]",
      matchers: ["skkeleton"],
      isVolatile: true,
    },
  },
  {
    name: "buffer",
    options: {
      mark: "[Buffer]",
      matchers: ["matcher_fuzzy"],
      sorters: ["sorter_fuzzy"],
      converters: ["converter_fuzzy"],
      keywordPattern: "[a-zA-Z0-9-\_]+",
    },
    params: {
      fromAltBuf: true,
    },
  },
];

export class Config extends BaseConfig {
  async config(_args: ConfigArguments): Promise<void> {
    const { denops, contextBuilder } = _args;
    contextBuilder.patchGlobal({
      ui: "native" satisfies "native" | "pum",
      sources: [
        {
          name: "nvim-lsp",
          params: {
            snippetEngine: async (body: unknown) => {
              await denops.call("vsnip#anonymous", body);
              return await Promise.resolve();
            },
            enableResolveItem: true,
            enableAdditionalTextEdit: true,
            confirmBehavior: "replace",
          },
          options: {
            mark: "[LS]",
            matchers: ["matcher_fuzzy"],
            sorters: ["sorter_fuzzy"],
            converters: ["converter_fuzzy", "converter_kind_labels"],
            ignoreCase: true,
            minAutoCompleteLength: 1,
          },
        },
        ...generalSources,
      ],
      autoCompleteEvents: [
        "TextChangedI",
        "TextChangedP",
        "CmdlineChanged",
      ],
      backspaceCompletion: true,
      cmdlineSources: {
        ":": [
          {
            name: "cmdline",
            options: {
              matchers: ["matcher_fuzzy"],
              sorters: ["sorter_fuzzy"],
              converters: ["converter_fuzzy"],
            },
          },
        ],
      },
    });
    contextBuilder.patchFiletype("vim", {
      sources: [
        {
          name: "necovim",
          options: {
            mark: "[Vim]",
            matchers: ["matcher_fuzzy"],
            sorters: ["sorter_fuzzy"],
            converters: ["converter_fuzzy"],
          },
        },
        ...generalSources,
      ],
    });

    return await Promise.resolve();
  }
}
