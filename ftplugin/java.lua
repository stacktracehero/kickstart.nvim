local jdtls = require 'jdtls'
local home = os.getenv 'HOME'
local mason_path = vim.fn.stdpath 'data' .. '/mason/packages'

local os_config = 'config_linux'
if vim.fn.has 'mac' == 1 then
  os_config = 'config_mac'
elseif vim.fn.has 'win32' == 1 then
  os_config = 'config_win'
end
local config_dir = mason_path .. '/jdtls/' .. os_config

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath 'cache' .. '/jdtls/workspace' .. project_name
local launcher_jar = vim.fn.glob(mason_path .. '/jdtls/plugins/org.eclipse.equinox.launcher_*.jar')
local lombok_jar = mason_path .. '/jdtls/lombok.jar'

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',

    '-javaagent:' .. lombok_jar,

    '-jar',
    launcher_jar,
    '-configuration',
    config_dir,
    '-data',
    workspace_dir,
  },

  root_dir = jdtls.setup.find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },

  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      completion = {
        favoriteStaticMembers = {
          'org.hamcrest.MatcherAssert.assertThat',
          'org.hamcrest.Matchers.*',
          'org.junit.jupiter.api.Assertions.*',
        },
      },
    },
  },
}

jdtls.start_or_attach(config)
