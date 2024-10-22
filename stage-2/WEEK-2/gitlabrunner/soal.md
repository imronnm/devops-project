Repository && Reference:
[Runner](https://docs.gitlab.com/runner/)
[wget spider](https://www.labnol.org/software/wget-command-examples/28750/)

Tasks :
- Implementasikan penggunaan Gitlab Runner pada aplikasi Frontend Kalian
- Buatlah beberapa Job untuk aplikasi kalian yang telah kalian deploy di task sebelumnya (staging && production)
  - Untuk script CICD atur flow pengupdate an aplikasi se freestyle kalian dan harus mencangkup
     - Pull dari repository
     - Dockerize/Build aplikasi kita
     - Test application
     - Push ke Docker Hub
     - Deploy aplikasi on top Docker
- Auto trigger setiap ada perubahan di SCM
- Buat job notification ke discord