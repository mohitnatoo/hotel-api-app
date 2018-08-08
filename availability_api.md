### Availability API

#### Description
 
This API is responsible for letting user know if room is available in a particular duration


#### Route

 `/hotels/:hotel_id/room_types/:room_type_id/availability`


#### Method

 `GET`


#### Parameters

**hotel_id** -> id of the hotel for which availability is to be seen.

**room_type_id** -> id of the room type that is to be searched for in the hotel.

**start_date** -> date of moving in.

**end_date** -> date of moving out.


#### Statuses

**404 (Not Found)** 

Returned in following situations
1. There is no hotel in the system with the provided hotel id.
2. There is no room type in the system with the provided room type id.
3. Both hotel and room types exist in system but the hotel doesn't not have any room with the given room type.

**400 (Bad Request)**

Returned in following cases:
1. When any of the parameters are missing.
2. When validation of the passed parameters fail. (eg: if start date is greater than end date)

**500 (Internal Server Error)**

When there are errors raised in the app.

**200 (OK)**
 
 On successful completion of request


#### Response

**start_date** - start date passed in the paramenters

**end_date** - start date passed in the paramenters

**available** - Boolean value whether room is available

**available_count** - no of rooms available of the given room type in the hotel in the date range

**rent** - total rate of 30 days of the average rate in the duration. 

**currency** - currency in which the rent is calculated


#### Example Response

```json
{
"start_date"      : "2018-06-24",
"end_date"        : "2018-07-24",
"available"       : "true",
"available_count" : "4",
"rent"            : "1050",
"currency"        : "USD"
}
```
