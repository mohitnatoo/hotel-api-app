### Reservation API

#### Description 

This API is responsible for reserving selected room and carrying out stripe payment.


#### Route

 `/hotels/:hotel_id/room_types/:room_type_id/rate`


#### Method

 `PATCH`


#### Parameters
**hotel_id** -> id of the hotel for which availability is to be seen.

**room_type_id** -> id of the room type that is to be searched for in the hotel.

**start_date** -> date of moving in.

**end_date** -> date of moving out.

**user_id** -> id of the user for whom the reservation should be carried out.

**price** -> The price to be paid. This will be got through stripe checkout.

**currency** -> The currency of the amount to be charged.

**source** -> This parameter will be got from stripe. 


#### Statuses

**404 (Not Found)** 

Returned in following cases:
1. There is no hotel in the system with the provided hotel id.
2. There is no room type in the system with the provided room type id.
3. Both hotel and room types exist in system but the hotel doesn't not have any room with the given room type.

***422 (Unprocessable Entity)**

Returned when all parameters are valid but there is no room available for reservation.

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

**reservation_id** - id of the reservation record that has got created.

**transaction_id** - id of the payment transaction record that is recorded in the database.

**stripe_charge_id** - id of the stripe charge returned by stripe api.


#### Example Response

```json
{
"reservation_id"   : 100,
"transaction_id"   : 200,
"stripe_charge_id" : "Alnlk03ndkl"
}
```