# Configuração Inicial no iOS

Para iniciar a configuracão inicial no iOS precisamos instalar o SDK do Liveness3D da Oititec, seguindo os seguintes passos:

## Passo 1: Criar Podfile

Acesse a pasta `ios` e execute o comando para criar o arquivo de Pods, caso já exista você pode pular esse passo.

```bash
pod init
```

## Passo 2: Especificar a versão mínima do iOS no projeto

No arquivo `Podfile` na raiz da pasta iOS, informe qual será a versão mínima usada no projeto para que as depedências sejam instaladas de acordo com esse requisito mínimo.

- [Acessar arquivo de exemplo](../../ios/Podfile).

```ruby
platform :ios, '11.0'
```

## Passo 3: Especificar as dependências

No arquivo `Podfile` na raiz da pasta iOS, informe as dependências do Flutter e do SDK iOS da Oiti (FaceCaptcha):

- [Acessar arquivo de exemplo](../../ios/Podfile).

```ruby
  pod 'Flutter'
  pod 'FaceCaptcha', '5.1.0', :source => 'https://github.com/oititec/liveness-ios-specs'
```

## Passo 4: Instalar as dependências

Ainda na pasta `ios` Execute o comando de instalação dos Pods.

```bash
pod install
```

## Passo 5: Permissão para uso da câmera

Ambos os módulos, Liveness 2D e Doc Core, fazem uso da câmera, por isso é necessário caso explicitar o uso desse recurso no `Info.plist` do projeto.

- [Acessar arquivo de exemplo](../../ios/Runner/Info.plist).

```xml
<key>NSCameraUsageDescription</key>
<string>Acesso a câmera</string>
```

_Adição pelo Xcode_

Chave: `Privacy - Camera Usage Description`

<div style="align:center;">
  <img src="../images/ios_camera_permission.png"/>
</div>