### Reservation API

#### Description 

This API is responsible to enable hotel partners to update price of a room on a daily basis


#### Route

 `/hotels/:hotel_id/room_types/:room_type_id/reservations`


#### Method

 `POST`


#### Parameters
**hotel_id** -> id of the hotel for which availability is to be seen.

**room_type_id** -> id of the room type that is to be searched for in the hotel.

**date** -> date for which price is to be updated

**price** -> the new price that is to be set


#### Statuses

**404 (Not Found)** 

Returned in following cases:
1. There is no hotel in the system with the provided hotel id.
2. There is no room type in the system with the provided room type id.
3. Both hotel and room types exist in system but the hotel doesn't not have any room with the given room type.

**400 (Bad Request)**

Returned in following cases:
1. When any of the parameters are missing.
2. When validation of the passed parameters fail. (eg: if start date is greater than end date)

**500 (Internal Server Error)**

Returned in following cases:
1. Payment failed from stripe.
2. Any unhandled errors raised in the app. 

**200 (OK)**

On successful completion of request


#### Response

**date** - date for which price was updated

**price** - price that was set

**hotel_room_price_id** - id of the hotel_room_price record in the db that was updated in the request.


#### Example Response

```json
{
"date"                : "2018-06-24",
"price"               : 25,
"hotel_room_price_id" : 500
}
```