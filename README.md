
# 吴查理运行记录

[原始文档说明](./ORIGN_README.md)
确定服务器部署后

## 依赖安装

node 版本 v22.13.0 +
```
node -v
```
npm 版本 10.9.2 +
```
npm -v
```
安装命令
```
npm install  --legacy-peer-deeps
```


## 运行命令

```
npm run dev
```


##  更改为线上环境验证是否成功

修改文件 1 ：config.ts
修改内容：PRODUCTION_HOSTNAME  缓存自己的域名 
```
export const PRODUCTION_HOSTNAME = '43.160.166.241';

```
修改文件 2： gramejs\Utils 
修改内容：端口修改和IP地址 
```
ipAddress:`webim.customgoodservice.icu`,
port: 5222,
```
修改文件 3： HttpStream.ts
修改内容：ws 链接修改
修改文件位置：
```
   static getURL(ip: string, port: number, isTestServer?: boolean, isPremium?: boolean) {
        if (port === 443) {
            console.log(`http://webim.customgoodservice.icu:11443/apiw1${isTestServer ? '_test' : ''}${isPremium ? '_premium' : ''}`)
            return `http://webim.customgoodservice.icu:11443/apiw1${isTestServer ? '_test' : ''}${isPremium ? '_premium' : ''}`;
            // return `http://127.0.0.1:8801/apiw1${isTestServer ? '_test' : ''}${isPremium ? '_premium' : ''}`;
        } else {
            console.log(`http://webim.customgoodservice.icu:10443/apiw1${isTestServer ? '_test' : ''}${isPremium ? '_premium' : ''}`)
            return `http://webim.customgoodservice.icu:10443/apiw1${isTestServer ? '_test' : ''}${isPremium ? '_premium' : ''}`;
        }
    }
```
修改文件 4：PromisedWebSockets
修改文件内容:WS 端口修改
修改文件位置：src\lib\gramjs\extensions\PromisedWebSockets.ts
```
    getWebSocketLink(ip: string, port: number, isTestServer?: boolean, isPremium?: boolean) {
        console.log(`1ws://${ip}:${port}/apiws${isTestServer ? '_test' : ''}${isPremium ? '_premium' : ''}`)
        if (port === 443) {
            // return `wss://${ip}:${port}/apiws${isTestServer ? '_test' : ''}${isPremium ? '_premium' : ''}`;
             return `ws://webim.customgoodservice.icu:11443/apiws${isTestServer ? '_test' : ''}${isPremium ? '_premium' : ''}`;
        } else {
            // return `ws://${ip}:${port}/apiws${isTestServer ? '_test' : ''}${isPremium ? '_premium' : ''}`;
            return `ws://webim.customgoodservice.icu:11443/apiws${isTestServer ? '_test' : ''}${isPremium ? '' : ''}`;
        }
    }
```
修改文件 5: webpack.config.ts
修改文件内容: CSP 跨域
修改文件位置：webpack.config.ts
```
  connect-src 'self' ws://webim.customgoodservice.icu:11443 wss://*.webim.customgoodservice.icu blob: http: https: ${APP_ENV === 'development' ? 'wss:' : ''};
  script-src 'self' 'wasm-unsafe-eval' http://127.0.0.1:54321 https://teamgram.net https://teamgram.me/_websync_;
  
  'Access-Control-Allow-Origin': '*',     

```

修改文件 6： AuthPhoneNumber.tsx
修改文件内容： 增加默认选中区号，保证业务畅通
修改文件位置：src\components\auth\AuthPhoneNumber.tsx
```
const defaultMockPhoneCodes: ApiCountryCode[] = [
  { iso2: 'CN', countryCode: '86', name: 'China', defaultName: '中国', prefixes: ['13','14','15','16','17','18','19'], patterns: ["^1[3-9]\\d{9}$"], isHidden: false },
  { iso2: 'US', countryCode: '1', name: '美国', defaultName: 'United States', prefixes: ['201','202','212','213'], patterns: [], isHidden: false },
  { iso2: 'GB', countryCode: '44', name: '英国', defaultName: 'United Kingdom', prefixes: ['20','23','24','29'], patterns: [], isHidden: false },
];


const [country, setCountry] = useState<ApiCountryCode>(
    phoneCodeList && phoneCodeList.length
      ? phoneCodeList[0]
      : defaultMockPhoneCodes[0]
);

```


## Docker 部署

制作镜像
```
docker build -t teamgram-tt-web .
```
启动镜像
```
docker run -d -p 54321:80 --name teamgram-tt-web teamgram-tt-web
```