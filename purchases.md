# Работа с подписками

## Общий алгоритм

- Создаем продукты в google play и apple store - они должны соответствовать текущим продуктам которые можно купить на сайте, цену менять нельзя после того как продукт уже был хоть раз куплен, надо будет делать новый продукт

- Информацию о купленных продуктах надо будет хранить на сервере для эпла и гугла отдельно, хранится будет JSON бъект, в котором будет информация необходимая для проверки - активна ли подписка в гугле и эпле

- Каждый раз когда человек открывает приложение, приложение будет получать актуальный статус своих подписок и отправлять на сервер, на сервере их надо будет эту информаци сохранить и дополнительно запросить проверку у эпла и гугла соответственно

- Инфомрацию о том истекла ли подписка можно будет узнать только сделав запрос к гуглу или эпплу, колбеков они не сделают

## Проверка в google

- Информация о методе тут: https://developers.google.com/android-publisher/api-ref/rest/v3/purchases.subscriptions

- Для проверки понадобится appBundle, productId и purchaseToken, эти параметры отдаст гугл на мобилку, как только подписка будет оплачена. Мобильное приложение отправляет эти данные на сервер. Вообще мобильное приложение может в любой момент понять какие именно подписки у него сейчас есть, важный момент - надо будет смотреть, на какой учетке в вашей системе куплена подписка - пользователь может выйти из вашей системы и зайти под другим пользователем - и он получит данные о купленной подписке.

- Сама проверка на гугле - productId и purchaseToken передаются в запрос `https://www.googleapis.com/androidpublisher/v3/applications/${appBundle}/purchases/subscriptions/${productId}/tokens/${purchaseToken}`

- Aвторизация
```js
const requestOptions = {
                    method: 'GET',
                    uri: requestQuery,
                    headers: {
                        'Authorization': `Bearer ${tokens.access_token}`
                    },
                };
```

- Token зависит от СДК на js это выглядит так (библиотека gtoken):
```js
GoogleToken({key: "-----BEGIN PRIVATE KEY----- TOKEN PRIVATE KEY -----END PRIVATE KEY-----",
            email: "tokenowner@email.com",
            scope: ['https://www.googleapis.com/auth/androidpublisher'] })
```

- В ответ гугл отправит результат проверки подписки

## Проверка в apple

- Информация о методе проверки тут https://developer.apple.com/documentation/appstorereceipts/verifyreceipt

- Для проверки понадобится пароль и receiptData. Логика такая же как и в андройде - мобилка получает информацию о подписке и отправляет ее на сервер, там ее сохранют и перепроверяют

- Есть возможность делать проверки в тестовом окружении в sandbox

- Пароль можно будет получить в админке учетки эппл девелопера вот так: https://help.apple.com/app-store-connect/#/devf341c0f01

- Cам запрос:

```js
const requestQuery = useSandbox ? `https://sandbox.itunes.apple.com/verifyReceipt` : `https://buy.itunes.apple.com/verifyReceipt`

const rBody = {
    'receipt-data': receiptData,
    'password': 'SOMEAPPLEPASSWORD'
}

const requestOptions = {
    method: 'POST',
    uri: requestQuery,
    body: rBody,
    json: true
};

const responseFromApple = await request(requestOptions)
```
