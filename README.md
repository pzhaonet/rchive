# rchive

This is an R package for a Shiny app used for [R-devel](https://stat.ethz.ch/pipermail/r-devel/), [R-help](https://stat.ethz.ch/pipermail/r-help) and [COS](https://d.cosx.org/) Archives.

Install and run:

```r
remotes::install_github("pzhaonet/rchive")
rchive::rchive()
```

or in RStudio - Addins - Rchive.

For the first time you use it, you have to wait (with doing nothing) about 10 seconds before the data is (down)loaded.

The onlne database is updated on a daily base. It means, if you click the 'Update' button today, you don't have to click it again until tomorrow.

If you don't want to install it, you could ues the [online version](sciwis.shinyapps.io/rchive/).

----

# 洛阳铲

## 简介

R 语言社区挖坟小能手 “洛阳铲”上线了。

这个 R 包用来在[统计之都](https://d.cosx.org/)、[R 帮助邮件列表](https://stat.ethz.ch/pipermail/r-help)、[R 开发者邮件列表](https://stat.ethz.ch/pipermail/r-devel/)里搜寻帖子。来龙去脉看[这里](https://d.cosx.org/d/420739)。

## 安装

```r
remotes::install_github("pzhaonet/rchive")
```

## 运行

两种方式运行。

喜欢敲代码的，在 R 语言环境下运行代码：

```r
rchive::rchive()
```

喜欢点鼠标的，使用 RStudio 的插件：RStudio - Addins - Rchive

## 注意事项

初次运行后需要干瞪眼大约 10 秒钟，啥都别点，等待数据从 GitHub 载入。如果你连不上 GitHub 我就没辙了。

GitHub 上的数据是用 Travis 每天自动更新的。所以，如果你今天点击了“Update”按钮，那明天之前就不用点了，点了也没用。

## 其他

这个工具有个[在线免安装版online version](sciwis.shinyapps.io/rchive/)。


