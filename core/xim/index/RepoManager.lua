-- remote package repo manager
-- 1. auto update - enable or disable | day week month
-- 2. multi-repo support
-- 3. private repo support

import("xim.base.runtime")

local data_dir = runtime.get_xim_data_dir()

local RepoManager = {}
RepoManager.__index = RepoManager

local gitee_repo = "https://gitee.com/sunrisepeak/xim-pkgindex.git"
local github_repo = "https://github.com/d2learn/xim-pkgindex.git"

function new()
    RepoManager.repos = { }
    if is_host("windows") then
        table.insert(RepoManager.repos, gitee_repo)
    else
        table.insert(RepoManager.repos, github_repo)
    end
    RepoManager.updateSchedule = 30   -- days
    return RepoManager
end

function RepoManager:sync()
    for _, repo in ipairs(self.repos) do
        print("[xlings: xim]: sync package index repo:", repo)
        local repodir = _to_repodir(repo)
        if os.isdir(repodir) then
            os.cd(repodir)
            os.exec("git pull")
        else
            os.cd(data_dir)
            os.exec("git clone " .. repo)
        end
    end
end

function RepoManager:repodirs()
    local dirs = {}
    for _, repo in ipairs(self.repos) do
        local repodir = _to_repodir(repo)
        if not os.isdir(repodir) then
            os.cd(data_dir)
            os.exec("git clone " .. repo)
        end
        table.insert(dirs, repodir)
    end
    return dirs
end

function _to_repodir(repo)
    local dir = string.split(path.filename(repo), ".git")[1]
    local repodir = path.join(data_dir, dir)
    return repodir
end

function main()
    local repoManager = new()
    repoManager:sync()
    print(repoManager:repodirs())
    print(_to_repodir("my/myrepo"))
end