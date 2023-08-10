# Configuração Inicial no Android

Para iniciar a configuracão inicial no Android precisamos instalar o SDK do Liveness 2D da Oititec, seguindo os seguintes passos:

## Passo 1: Especificar o repositório Maven do SDK

No arquivo `build.gradle` na raiz da pasta android em `allprojects`, adicione o endereço do repositório de artefatos:

- [Acessar arquivo de exemplo](../../android/build.gradle).

```gradle
allprojects {
    repositories {
        maven { url "https://raw.githubusercontent.com/oititec/android-oiti-versions/master" }
    }
}
```

## Passo 2: Adicionar a dependência do Liveness2D

No arquivo `build.gradle` na pasta android/app, adicione a dependência:

- [Acessar arquivo de exemplo](../../android/app/build.gradle).

```gradle
dependencies {
    implementation 'br.com.oiti:liveness2d-sdk:5.7.0'
}
```

## Passo 3: Definir a versão mínima do SDK

No arquivo `build.gradle` na pasta android/app em `defaultConfig`, especifique a versão mínima do SDK como sendo **21**:

- [Acessar arquivo de exemplo](../../android/app/build.gradle).

```gradle
defaultConfig {
    minSdkVersion 21
}
```