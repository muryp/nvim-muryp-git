local M = require('nvim-muryp-git.git')
local IMPORT_GH_MAPS = ":lua require('nvim-muryp-git.gh.cmd')"

return {
  name = "GIT",
  b = { ':Telescope git_branches<CR>', "BRANCH" },
  f = { ':Telescope git_flow<CR>', "FLOW" },
  i = {
    c = { ':Telescope git_issue_cache<CR>', "LIST_ISSUE_ON_CACHE" },
    i = { ':Telescope git_issue<CR>', "EDIT_ISSUE" },
    o = { IMPORT_GH_MAPS .. ".addIssue()<CR>", "GET_ISSUE_BY_NUM" },
    a = { ':term gh issue create<CR>', "ADD_ISSUE" },
    s = { IMPORT_GH_MAPS .. ".push()<CR>", "SYNC_LOCAL_TO_GH" },
    S = { IMPORT_GH_MAPS .. ".update()<CR>", "SYNC_GH_TO_LOCAL" },
    e = { IMPORT_GH_MAPS .. ".edit()<CR>", "EDIT" },
    d = { IMPORT_GH_MAPS .. ".delete()<CR>", "DELETE" },
    p = { IMPORT_GH_MAPS .. ".pin()<CR>", "pin" },
    P = { IMPORT_GH_MAPS .. ".unpin()<CR>", "unpin" },
    l = { IMPORT_GH_MAPS .. ".lock()<CR>", "lock" },
    L = { IMPORT_GH_MAPS .. ".unlock()<CR>", "unlock" },
    r = { IMPORT_GH_MAPS .. ".reopen()<CR>", "reopen" },
    C = { IMPORT_GH_MAPS .. ".unlock()<CR>", "closed" },
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
        ssh=true,
      })
    end, "SSH+PULL+PUSH" },
    S = { function()
      M.gitMainCmd({
        push = true,
        remote_quest = true,
        ssh=true,
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
