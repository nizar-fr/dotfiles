vim.filetype.add {
  extension = {
    vert = "glsl",
    tesc = "glsl",
    tese = "glsl",
    frag = "glsl",
    geom = "glsl",
    comp = "glsl",
  },
}

local cmd = {
  "ngserver",
  "--stdio",
  "--tsProbeLocations",
  -- project_library_path,
  "--ngProbeLocations",
  -- project_library_path,
}

vim.lsp.config("angularls", {
  cmd = cmd,
})
require("lspconfig").angularls.setup {
  filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
}

-- vim.lsp.config("roslyn", {
--     on_attach = function()
--         print("This will run when the server attaches!")
--     end,
--     settings = {
--         ["csharp|inlay_hints"] = {
--             csharp_enable_inlay_hints_for_implicit_object_creation = true,
--             csharp_enable_inlay_hints_for_implicit_variable_types = true,
--         },
--         ["csharp|code_lens"] = {
--             dotnet_enable_references_code_lens = true,
--         },
--     },
-- })


require("mason").setup {
  registries = {
    "github:mason-org/mason-registry",
    "github:crashdummyy/mason-registry",
  },
}


