local M = require('nvim-muryp-git.git')
local IMPORT_GH_MAPS = ":lua require('nvim-muryp-git.telescope.gh.ghIssue.cmd')"

return {
  name = "GIT",
  b = { ':Telescope git_branches<CR>', "BRANCH" },
  f = { ':Telescope git_flow<CR>', "FLOW" },
  i = {
    c = { ':Telescope git_issue_cache<CR>', "EDIT_ISSUE_ON_CACHE" },
    i = { ':Telescope git_issue<CR>', "EDIT_ISSUE" },
    o = { IMPORT_GH_MAPS .. ".addIssue", "ADD_ISSUE_TO_CHACE" },
    a = { ':term gh issue create<CR>', "ADD_ISSUE" },
    p = { IMPORT_GH_MAPS .. ".push()<CR>", "PUSH_INTO_GH" },
    e = { IMPORT_GH_MAPS .. ".edit()<CR>", "EDIT" },
    u = { IMPORT_GH_MAPS .. ".update()<CR>", "UPDATE_LOCAL" },
    d = { IMPORT_GH_MAPS .. ".delete()<CR>", "DELETE" },
  },
  s = { ':Telescope git_status<CR>', "GIT_STATUS" },
  c = { ':term git commit<CR>', "COMMIT" },
  v = { function()
    M.gitMainCmd({
      add = true,
      commit = true,
    })
  end, "ADD_ALL+COMMIT" },
  p = {
    name = "PUSH",
    p = { function()
      M.gitMainCmd({
        add = true,
        commit = true,
        ssh = true,
        remote_quest = true,
        pull_quest = true,
        push = true,
      })
    end, "ADD+COMMIT+SSH+PULL+PUSH" },
    P = { function()
      M.gitMainCmd({
        remote_quest = true,
        push = true,
      })
    end, "PUSH" },
    a = { function ()
      vim.cmd(':term ' .. M.SSH_CMD() .. ' && git push --all<CR>')
    end, "PUSH ALL WITH SSH" },
    A = { ':term git push --all<CR>', "PUSH ALL" },
    s = { function()
      M.gitMainCmd({
        push = true,
        remote_quest = true,
        pull_quest = true,
      })
    end, "SSH+PULL+PUSH" },
    S = { function()
      M.gitMainCmd({
        push = true,
        remote_quest = true,
      })
    end, "SSH+PUSH" },
  },
  P = {
    name = "PULL",
    A = { ':term git pull --all<CR>', "PULL ALL" },
    a = { function ()
      vim.cmd(':term ' .. M.SSH_CMD() .. ' && git pull --all<CR>')
    end, "PULL ALL WITH SSH" },
    p = { function()
      M.gitMainCmd({
        remote_quest = true,
        pull = true,
      })
    end, "PULL THIS BRANCH" },
    P = { function()
      M.gitMainCmd({
        remote_quest = true,
        pull = true,
        ssh = true,
      })
    end, "PULL THIS BRANCH WITH SSH" },
  },
  o = {
    name = "WITH TELESCOPE OPTS",
    p = { ':Telescope git_commit_ssh_push<CR>', "COMMIT+SSH+PULL+PUSH" },
    P = { ':Telescope git_pull<CR>', "PULL" },
  },
}
