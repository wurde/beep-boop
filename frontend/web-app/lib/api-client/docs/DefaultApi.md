# MainApi.DefaultApi

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getUserById**](DefaultApi.md#getUserById) | **GET** /users/{id} | Retrieve user details
[**listUsers**](DefaultApi.md#listUsers) | **GET** /users | List users
[**logEvent**](DefaultApi.md#logEvent) | **POST** /events | Log an event



## getUserById

> User getUserById(id)

Retrieve user details

### Example

```javascript
import MainApi from 'main_api';

let apiInstance = new MainApi.DefaultApi();
let id = null; // Object | The ID of the user to retrieve.
apiInstance.getUserById(id, (error, data, response) => {
  if (error) {
    console.error(error);
  } else {
    console.log('API called successfully. Returned data: ' + data);
  }
});
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | [**Object**](.md)| The ID of the user to retrieve. | 

### Return type

[**User**](User.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## listUsers

> Object listUsers()

List users

### Example

```javascript
import MainApi from 'main_api';

let apiInstance = new MainApi.DefaultApi();
apiInstance.listUsers((error, data, response) => {
  if (error) {
    console.error(error);
  } else {
    console.log('API called successfully. Returned data: ' + data);
  }
});
```

### Parameters

This endpoint does not need any parameter.

### Return type

**Object**

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## logEvent

> logEvent(cloudEvent)

Log an event

### Example

```javascript
import MainApi from 'main_api';

let apiInstance = new MainApi.DefaultApi();
let cloudEvent = new MainApi.CloudEvent(); // CloudEvent | 
apiInstance.logEvent(cloudEvent, (error, data, response) => {
  if (error) {
    console.error(error);
  } else {
    console.log('API called successfully.');
  }
});
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cloudEvent** | [**CloudEvent**](CloudEvent.md)|  | 

### Return type

null (empty response body)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: application/cloudevents+json
- **Accept**: Not defined

