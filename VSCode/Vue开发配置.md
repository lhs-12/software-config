# <center>Vue项目开发配置</center>

# 环境安装配置

## Node.js 安装
官网下载安装 node.js  
国内镜像`npm install -g cnpm --registry=https://registry.npm.taobao.org`

安装yarn: `npm install -g yarn`, 并将`yarn global dir`路径下的`/node_modules/.bin`添加到环境变量  
国内镜像(不用国内镜像也挺快)`yarn config set registry https://registry.npm.taobao.org/`

## 依赖
> 试过用 npm install 装 vue-cli 报错, 换成 yarn 就正常.而且yarn下载更快, 所以更多是用yarn

用 npm 和 yarn 安装均可, 命令: `cnpm install [依赖名] -g` , `yarn global add [依赖名]`  
依赖: `webpack`, `@vue/cli`

## 软件安装配置
> 以下内容属于vue2版本，已过时

| 软件       | 版本 |
| ---------- | ---- |
| VSCode     | 1.51 |
| Vetur插件  | 0.30 |
| ESLint插件 | 2.10 |
| @vue/cli   | 4.50 |

VSCode加入配置
```
"vetur.validation.template": false, // 使用ESLint代替Vetur自带的ESLint, 参考Vetur官方文档
```

# 项目初始化(ESLint检查 + Prettier格式化)
`vue create hello-world`, 创建项目时就可以选择好ESLint和Prettier  
如果vue-cli创建时没有选prettier, 则执行以下的添加prettier依赖操作
```sh
npm install --save-dev eslint-plugin-prettier @vue/eslint-config-prettier
或
yarn add --dev eslint-plugin-prettier @vue/eslint-config-prettier
```
ESLint配置文件(.eslintrc.js)中  
extends加入"@vue/prettier", 另外建议将"plugin:vue/essential"升到"strongly-recommended"级别
```js
extends: ["plugin:vue/strongly-recommended", "eslint:recommended", "@vue/prettier"],
```

项目中加入Prettier配置文件(.prettierrc.js)
```js
module.exports = {
    tabWidth: 2,
    printWidth: 160,
    trailingComma: "all",
}
```