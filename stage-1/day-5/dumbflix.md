# Deployment Dumbflix (Node JS)

## 1. git clone https://github.com/dumbwaysdev/dumbflix-frontend.git
![git clone](assets/images/1.png) <br>

## 2. cd dumbflix-frontend
![cd](assets/images/2.png) <br>

## 3. install nvm

- command: install nvm
 ```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh

```
![install-nvm](assets/images/3.png) <br>

- command: configurasi nvm
 ```bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
```
![configurasi-nvm](assets/images/4.png) <br>

## 4. install node version 14

- command: install version 14
```bash
nvm i 14
```

- command: use version 14
```bash
nvm use 14
```
![nvm-i](assets/images/5.png) <br>

## 5. Intall paket node modules dengan npm install

- command: npm install
```bash
npm install
```
![npm-install](assets/images/6.png) <br>

## 6. Jalankan Aplikasi dengan npm start
- command: npm start
```bash
npm start
```
![npm-start](assets/images/7.png) <br>

## 7. Tampilan APlikasi di browser
![tampilan-aplikasi](assets/images/8.png) <br>