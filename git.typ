#import "@preview/gentle-clues:1.3.1": *
#set text(font: "Noto Serif CJK SC", lang: "zh")

= Git笔记

== 创建版本库

```bash git init```: 把个目录变成Git可以管理的仓库：

```bash
$ git init
Initialized empty Git repository in /Users/michael/learngit/.git/
```
=== 把文件添加到版本库

创建一个readme.text文件：
```bash
Git is a version control system.
Git is free software.
```

+ 第一步，用命令git add告诉Git，把文件添加到仓库：
```bash
$ git add readme.txt
```
+ 第二步，用命令git commit告诉Git，把文件提交到仓库：
```bash
$ git commit -m "wrote a readme file"
[master (root-commit) eaadf4e] wrote a readme file
 1 file changed, 2 insertions(+)
 create mode 100644 readme.txt
```
```bash git commit```命令，`-m`后面输入的是本次提交的说明。
== 时光机穿梭

修改readme.txt文件：
```bash
Git is a distributed version control system.
Git is free software.
```
```bash git status```命令可以让我们时刻掌握仓库当前的状态:
```bash
$ git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   readme.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

```bash git diff```:比较工作区、暂存区和历史提交之间的差异。
```bash
$ git diff readme.txt
diff --git a/readme.txt b/readme.txt
index 46d49bf..9247db6 100644
--- a/readme.txt
+++ b/readme.txt
@@ -1,2 +1,2 @@
-Git is a version control system.
+Git is a distributed version control system.
 Git is free software.
```
#tip[
  - 要随时掌握工作区的状态，使用git status命令。
  - 如果git status告诉你有文件被修改过，用git diff可以查看修改内容。
]

=== 版本回退

修改readme.txt并提交：

```bash
Git is a distributed version control system.
Git is free software distributed under the GPL.
```
```bash git log```: 显示从最近到最远的提交日志
```bash
$ git log
commit 1094adb7b9b3807259d8cb349e7df1d4d6477073 (HEAD -> master)
Author: Michael Liao <askxuefeng@gmail.com>
Date:   Fri May 18 21:06:15 2018 +0800

    append GPL

commit e475afc93c209a690c39c13a46716e8fa000c366
Author: Michael Liao <askxuefeng@gmail.com>
Date:   Fri May 18 21:03:36 2018 +0800

    add distributed

commit eaadf4e385e865d25c48e7ca9c8395c3f7dfaef0
Author: Michael Liao <askxuefeng@gmail.com>
Date:   Fri May 18 20:59:18 2018 +0800

    wrote a readme file
```
如果嫌输出信息太多，看得眼花缭乱的，可以试试加上`--pretty=oneline`参数：
```bash
$ git log --pretty=oneline
1094adb7b9b3807259d8cb349e7df1d4d6477073 (HEAD -> master) append GPL
e475afc93c209a690c39c13a46716e8fa000c366 add distributed
eaadf4e385e865d25c48e7ca9c8395c3f7dfaef0 wrote a readme file
```
在Git中，用`HEAD`表示当前版本，也就是最新的提交`1094adb...`，上一个版本就是`HEAD^`，上上一个版本就是`HEAD^^`，当然往上100个版本写100个^比较容易数不过来，所以写成`HEAD~100`。

```bash git reset```:用于撤销或回退已经提交到仓库中的更改

#tip[
  - --hard会回退到上个版本的已提交状态
  - --soft会回退到上个版本的未提交状态
  - --mixed会回退到上个版本已添加但未提交的状态。
]

```bash
$ git reset --hard HEAD^
HEAD is now at e475afc add distributed
```
```bash
$ git log
commit e475afc93c209a690c39c13a46716e8fa000c366 (HEAD -> master)
Author: Michael Liao <askxuefeng@gmail.com>
Date:   Fri May 18 21:03:36 2018 +0800

    add distributed

commit eaadf4e385e865d25c48e7ca9c8395c3f7dfaef0
Author: Michael Liao <askxuefeng@gmail.com>
Date:   Fri May 18 20:59:18 2018 +0800

    wrote a readme file
```
*后悔药*：当你用```bash git reset --hard HEAD^```回退到`add distributed`版本时，再想恢复到`append GPL`，就必须找到`append GPL`的commit id。

#memo[
  ```bash git reflog```：当你执行任何会改变 HEAD 位置的操作时（例如 ```bash git checkout```, ```bash git reset```, ```bash git commit```, ```bash git merge``` 等），Git 都会将这个变更记录下来。```bash git reflog``` 命令就是用来查看这份记录的。]

```bash
$ git reflog
e475afc HEAD@{1}: reset: moving to HEAD^
1094adb (HEAD -> master) HEAD@{2}: commit: append GPL
e475afc HEAD@{3}: commit: add distributed
eaadf4e HEAD@{4}: commit (initial): wrote a readme file
```
#tip[
  - HEAD指向的版本就是当前版本，因此，Git允许我们在版本的历史之间穿梭，使用命令```bash git reset --hard commit_id```。
  - 穿梭前，用```bash git log```可以查看提交历史，以便确定要回退到哪个版本。
  - 要重返未来，用```bash git reflog```查看命令历史，以便确定要回到未来的哪个版本。
]

=== 工作暂存区

*工作区*：项目的工作目录

*版本库*：工作区有一个隐藏目录.git，这个不算工作区，而是Git的版本库。

#image("image/repo.png")

Git的版本库里存了很多东西，其中最重要的就是称为stage（或者叫index）的暂存区，还有Git为我们自动创建的第一个分支master，以及指向master的一个指针叫HEAD。

+ 第一步是用```bash git add```把文件添加进去，实际上就是把文件修改添加到暂存区；

+ 第二步是用```bash git commit```提交更改，实际上就是把暂存区的所有内容提交到当前分支。

=== 管理修改

每次修改，如果不用```bash git add```到暂存区，那就不会加入到commit中。

// 定义一个简单的表格函数，方便排版
#table(
  columns: 2,
  align: center,
  inset: 8pt,
  stroke: 1pt,
  [命令], [比较对象],
  [
    ```bash git diff```
  ],
  [
    工作区 vs 暂存区
  ],

  [
    ```bash git diff --cached```
  ],
  [
    暂存区 vs HEAD
  ],

  [
    ```bash git diff HEAD```
  ],
  [
    工作区 vs HEAD
  ],

  [
    ```bash git diff <commit1>..<commit2>```
  ],
  [
    任意两个提交之间
  ],

  [
    ```bash git diff <branch1>..<branch2>```
  ],
  [
    任意两个分支之间
  ],
)

=== 撤销修改

假如在readme.txt中添加了一行：
```bash
$ cat readme.txt
Git is a distributed version control system.
Git is free software distributed under the GPL.
Git has a mutable index called stage.
Git tracks changes of files.
My stupid boss still prefers SVN.
```
```bash git restore```:

#memo(title: [```bash git restore```])[
  ```bash
  git restore <file>         # 恢复单个文件
  git restore .              # 恢复所有被修改的文件

  git restore --staged <file> # 将文件从暂存区撤出，保留在工作区

  git restore --staged --worktree <file>  # 等同于 git checkout -- <file>
  # 也可以分开执行这两步
  # git restore --staged <file>  # 取消暂存
  # git restore <file>           # 恢复工作区
  ```
]

#table(
  columns: 3,
  align: (center, center, center),
  inset: 8pt,
  stroke: 1pt,
  [方面], [```bash git checkout -- <file>```], [```bash git restore <file>```],
  [
    目的
  ],
  [
    将工作区的文件恢复到最后一次提交 (HEAD) 的状态
  ],
  [
    将工作区的文件恢复到最后一次提交 (HEAD) 的状态
  ],

  [
    效果
  ],
  [
    丢弃对 `<file>` 的所有未暂存修改
  ],
  [
    丢弃对 `<file>` 的所有未暂存修改
  ],

  [
    结果
  ],
  [
    文件内容与 HEAD 提交时完全一致
  ],
  [
    文件内容与 HEAD 提交时完全一致
  ],
)

#table(
  columns: 3,
  align: (center, center, center),
  inset: 8pt,
  stroke: 1pt,
  [方面], [```bash git reset HEAD <file>```], [```bash git restore --staged <file>```],
  [
    目的
  ],
  [
    将指定文件从暂存区撤出
  ],
  [
    将指定文件从暂存区撤出
  ],

  [
    效果
  ],
  [
    文件从已暂存变为未暂存，保留工作区修改
  ],
  [
    文件从已暂存变为未暂存，保留工作区修改
  ],

  [
    结果
  ],
  [
    该文件的修改不再包含在下次 ```bash git commit``` 中
  ],
  [
    该文件的修改不再包含在下次 ```bash git commit``` 中
  ],

  [
    历史与风格
  ],
  [
    传统的、多功能的 `reset` 命令的一部分
  ],
  [
    新引入的、功能更明确的 `restore` 命令
  ],
)

=== 删除文件

#table(
  columns: 3,
  align: (center, center, center),
  inset: 8pt,
  stroke: 1pt,
  [方面], [手动删除文件后执行 ```bash git add```], [直接使用 ```bash git rm```],
  [
    操作步骤
  ],
  [
    2步：1. 手动 `rm` 文件。2. ```bash git add``` 告知 Git 文件被删除。
  ],
  [
    1步：```bash git rm``` 自动完成删除并告知 Git。
  ],

  [
    最终效果
  ],
  [
    相同。都将删除操作暂存起来，等待 ```bash git commit``` 来正式生效。
  ],
  [
    相同。都将删除操作暂存起来，等待 ```bash git commit``` 来正式生效。
  ],

  [
    便捷性
  ],
  [
    不够便捷，需要两个独立的命令。
  ],
  [
    更加便捷高效，一个命令完成所有操作。
  ],

  [
    安全性
  ],
  [
    你可以在执行 ```bash git add``` 之前，改变主意并恢复文件，而 Git 不会感知到删除操作。
  ],
  [
    文件一旦被 ```bash git rm```，就立刻进入了待提交的删除状态，无法轻易撤销（除非使用 ```bash git reset --hard``` 或从别的地方复制回来）。
  ],
)

== 远程仓库

*创建SSH Key*：

第1步：创建SSH Key。在用户主目录下，看看有没有.ssh目录，如果有，再看看这个目录下有没有*id_rsa*和*id_rsa.pub*这两个文件，如果已经有了，可直接跳到下一步。如果没有，打开Shell（Windows下打开Git Bash），创建SSH Key：

```bash
$ ssh-keygen -t rsa -C "youremail@example.com"
```
如果一切顺利的话，可以在用户主目录里找到.ssh目录，里面有*id_rsa*和*id_rsa.pub*两个文件，这两个就是SSH Key的秘钥对，*id_rsa*是私钥，不能泄露出去，*id_rsa.pub*是公钥，可以放心地告诉任何人。

第2步：登陆GitHub，打开“Account settings”，“SSH Keys”页面：

然后，点“Add SSH Key”，填上任意Title，在Key文本框里粘贴*id_rsa.pub*文件的内容。

=== 添加远程库

要关联一个远程库，使用命令```bash git remote add origin git@server-name:path/repo-name.git```；

关联一个远程库时必须给远程库指定一个名字，`origin`是默认习惯命名；

关联后，使用命令```bash git push -u origin master```第一次推送master分支的所有内容；

此后，每次本地提交后，只要有必要，就可以使用命令```bash git push origin master```推送最新修改；

如果添加的时候地址写错了，或者就是想删除远程库，可以用```bash git remote rm <name>```命令。使用前，建议先用```bash git remote -v```查看远程库信息

=== 从远程库克隆

要克隆一个仓库，首先必须知道仓库的地址，然后使用```bash git clone```命令克隆。

Git支持多种协议，包括https，但ssh协议速度最快。

== 分支管理

=== 创建与合并分支

创建并切换到`dev`分支：
```bash
$ git checkout -b dev
Switched to a new branch 'dev'
```
```bash git checkout -b dev```相当于以下两条命令：
```bash
git branch dev
git checkout dev
```
用```bash git branch```命令查看当前分支：
```bash
$ git branch
* dev
  master
```
```bash git merge```命令用于合并指定分支到当前分支。

```bash
$ git checkout master
Switched to branch 'master'

$ git merge dev
Updating d46f35e..b17d20e
Fast-forward
 readme.txt | 1 +
 1 file changed, 1 insertion(+)
```
删除`dev`分支：```bash git branch -d dev```
```bash
$ git branch -d dev
Deleted branch dev (was b17d20e).
$ git branch
* master
```
此外，创建并切换到新的`dev`分支还可以使用：
```bash
git switch -c dev
```
直接切换到已有的`master`分支，可以使用：
```bash
git switch master
```
#memo[
  查看分支：```bash git branch```

  创建分支：```bash git branch <name>```

  切换分支：```bash git checkout <name>```或者```bash git switch <name>```

  创建+切换分支：```bash git checkout -b <name>```或者```bash git switch -c <name>```

  合并某分支到当前分支：```bash git merge <name>```

  删除分支：```bash git branch -d <name>```
]

#clue(
  title: [#text(
    font: "Noto Serif CJK SC",
  )[建议使用```bash git switch```和```bash git restore```代替```bash git checkout```]],
  accent-color: gradient.linear(red, blue, dir: ttb),
  header-color: gradient.linear(red, yellow, blue),
  border-color: blue.darken(40%),
  body-color: yellow.lighten(80%),
  title-font: "Liberation Mono",
  title-weight-delta: 300,
)[


  = Git Switch 用法

  #table(
    columns: (auto, auto, 1fr),
    // 第三列自动占据剩余空间
    inset: 8pt,
    // 单元格内边距
    stroke: 1pt + black,
    // 表格边框
    align: left + horizon,
    // 内容左对齐且垂直居中

    // --- 表头 ---
    [场景], [命令示例], [说明],

    // --- 数据行 ---
    [切换分支], [```bash git switch <分支名>```], [切换到已存在的分支 (如 ```bash git switch main```)],

    [切回上一个], [```bash git switch -```], [快速在最近两个分支间切换 (类似 ```bash cd -```)],

    [创建并切换], [```bash git switch -c <新分支名>```], [-c 代表 create。等价于旧版的 ```bash git checkout -b```],

    [基于远程创建],
    [```bash git switch <远程分支名>```],
    [若本地不存在，自动创建并跟踪远程分支 (如 ```bash git switch origin/feat-1```)],

    [强制切换], [```bash git switch -f <分支名>```], [丢弃当前未提交的修改，强制切换 (慎用！)],

    [分离头指针], [```bash git switch --detach <commit-id>```], [进入临时查看历史版本的状态],
  )

  = Git Restore用法

  #table(
    columns: (auto, auto, 1fr),
    inset: 8pt,
    stroke: 1pt + black,
    align: left + horizon,

    // --- 表头 ---
    [场景], [命令示例], [说明],

    // --- 数据行 ---
    [撤销工作区修改],
    [```bash git restore <文件名>```],
    [
      丢弃工作区的修改，恢复到最近一次 `commit` 的状态。
      #linebreak()
      #emph[(等价于旧版 ```bash git checkout -- <file>```)]
    ],

    [撤销多个文件], [```bash git restore .```], [丢弃当前目录下所有未提交的修改 (高危操作)],

    [取消暂存 (Unstage)],
    [```bash git restore --staged <文件名>```],
    [
      将文件从“暂存区”移回“工作区”，保留修改内容。
      #linebreak()
      #emph[(等价于旧版 ```bash git reset HEAD <file>```)]
    ],

    [指定版本恢复],
    [```bash git restore -s <版本> <文件>```],
    [
      #raw("-s") (source) 指定从哪个 commit/branch 恢复文件。
      #linebreak()
      例：```bash git restore -s main config.js``` (用 main 分支的版本覆盖当前文件)
    ],
  )
]

