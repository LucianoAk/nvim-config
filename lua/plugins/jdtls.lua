return {
  "mfussenegger/nvim-jdtls",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mason.org/mason.nvim",
  },
  ft = { "java" },
  config = function()
    local mason_registry = require("mason-registry")
    local jdtls = require("jdtls")

    local mason_path = vim.fn.stdpath("data") .. "/mason"
    local lombok_jar = mason_path .. "/share/jdtls/lombok.jar"

    local cmd = {
      vim.fn.exepath("jdtls"),
      string.format("--jvm-arg=-javaagent:%s", lombok_jar),
    }

    local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
    local root_dir = function(path)
      return vim.fs.root(path, root_markers)
    end

    local project_name = function(rd)
      return rd and vim.fs.basename(rd) or ""
    end

    local bundles = {}
    local function setup_bundles()
      if mason_registry.is_installed("java-debug-adapter") then
        bundles = vim.fn.glob(mason_path .. "/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar", false, true)
        if mason_registry.is_installed("java-test") then
          vim.list_extend(bundles, vim.fn.glob(mason_path .. "/share/java-test/*.jar", false, true))
        end
      end
    end
    setup_bundles()

    local function get_capabilities()
      local capabilities = nil
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        capabilities = blink.get_lsp_capabilities()
      else
        local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
        if has_cmp then
          capabilities = cmp_lsp.default_capabilities()
        else
          capabilities = vim.lsp.protocol.make_client_capabilities()
        end
      end
      return capabilities
    end

    local function attach_jdtls()
      local fname = vim.api.nvim_buf_get_name(0)
      local current_root_dir = root_dir(fname)
      if not current_root_dir or current_root_dir == "" then
        return
      end

      local proj_name = project_name(current_root_dir)
      local config_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. proj_name .. "/config"
      local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. proj_name .. "/workspace"

      local full_cmd = vim.deepcopy(cmd)
      vim.list_extend(full_cmd, {
        "-configuration", config_dir,
        "-data", workspace_dir,
      })

      local config = {
        cmd = full_cmd,
        root_dir = current_root_dir,
        init_options = {
          bundles = bundles,
        },
        settings = {
          java = {
            inlayHints = {
              parameterNames = {
                enabled = "all",
              },
            },
          },
        },
        capabilities = get_capabilities(),
      }

      jdtls.start_or_attach(config)
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "java" },
      callback = attach_jdtls,
    })

    attach_jdtls()

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "jdtls" then
          local has_dap, _ = pcall(require, "dap")
          if has_dap and mason_registry.is_installed("java-debug-adapter") then
            jdtls.setup_dap({ hotcodereplace = "auto", config_overrides = {} })
            require("jdtls.dap").setup_dap_main_class_configs()
          end
        end
      end,
    })
  end,
}
