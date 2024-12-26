#!/bin/bash

USER_SERVICE="user-service:50051"
ORDER_PROCESSING_SERVICE="order-processing-service:50052"
ORDER_STATUS_SERVICE="order-status-service:50053"
PAYMENT_SERVICE="payment-service:50054"
REVIEW_SERVICE="review-service:50055"

echo "Test 1: UserService/CreateUser"

USER_NAME="Ivan Ivanov"
USER_EMAIL="ivanov@mail.com"

CREATE_USER_REQUEST='{
  "name": "'$USER_NAME'",
  "email": "'$USER_EMAIL'"
}'

CREATE_USER_RESPONSE=$(grpcurl -d "$CREATE_USER_REQUEST" -plaintext "$USER_SERVICE" UserService/CreateUser )

echo "GetUser response: $CREATE_USER_RESPONSE"

USER_ID=$(echo "$CREATE_USER_RESPONSE" | jq -r '.user_id')

if [ -z "$USER_ID" ]; then
  echo "Test failed: The user was not created or the user_id was not get."
  exit 1
  else
  echo "Test passed: User created successfully with user_id: $USER_ID"
fi

GET_USER_REQUEST='{
  "user_id": "'$USER_ID'"
}'

echo "Test 2: UserService/GetUser"

GET_USER_RESPONSE=$(grpcurl -d "$GET_USER_REQUEST" -plaintext "$USER_SERVICE" UserService/GetUser )

echo "GetUser response: $GET_USER_RESPONSE"

EXPECTED_NAME=$USER_NAME
ACTUAL_NAME=$(echo "$GET_USER_RESPONSE" | jq -r '.name')

if [ "$ACTUAL_NAME" == "$EXPECTED_NAME" ]; then
  echo "Test passed: User name matches."
else
  echo "Test failed: Expected name '$EXPECTED_NAME', but got '$ACTUAL_NAME'."
fi

EXPECTED_EMAIL=$USER_EMAIL
ACTUAL_EMAIL=$(echo "$GET_USER_RESPONSE" | jq -r '.email')

if [ "$ACTUAL_EMAIL" == "$EXPECTED_EMAIL" ]; then
  echo "Test passed: User email matches."
else
  echo "Test failed: Expected email '$EXPECTED_EMAIL', but got '$ACTUAL_EMAIL'."
fi

echo "Test 3: OrderProcessingService/CreateOrder"

CREATE_ORDER_REQUEST='{
  "user_id": "'$USER_ID'",
  "product_id": "product123",
  "quantity": 1
}'

CREATE_ORDER_RESPONSE=$(grpcurl -d "$CREATE_ORDER_REQUEST" -plaintext "$ORDER_PROCESSING_SERVICE" OrderProcessingService/CreateOrder)

echo "CreateOrder response: $CREATE_ORDER_RESPONSE"

ORDER_ID=$(echo "$CREATE_ORDER_RESPONSE" | jq -r '.order_id')

if [ -z "$ORDER_ID" ]; then
  echo "Test failed: The order was not created or the order_id was not retrieved."
  exit 1
else
  echo "Test passed: Order created successfully with order_id: $ORDER_ID"
fi

echo "Test 4: OrderProcessingService/GetOrder"

GET_ORDER_REQUEST='{
  "order_id": "'$ORDER_ID'"
}'

GET_ORDER_RESPONSE=$(grpcurl -d "$GET_ORDER_REQUEST" -plaintext "$ORDER_PROCESSING_SERVICE" OrderProcessingService/GetOrder)

echo "GetOrder response: $GET_ORDER_RESPONSE"

EXPECTED_ORDER_ID=$ORDER_ID
ACTUAL_ORDER_ID=$(echo "$GET_ORDER_RESPONSE" | jq -r '.order_id')

if [ "$ACTUAL_ORDER_ID" == "$EXPECTED_ORDER_ID" ]; then
  echo "Test passed: Order ID matches."
else
  echo "Test failed: Expected order ID '$EXPECTED_ORDER_ID', but got '$ACTUAL_ORDER_ID'."
fi

echo "Test 5: OrderStatusService/CreateOrderStatus"

CREATE_ORDER_STATUS_REQUEST='{
  "order_id": "'$ORDER_ID'",
  "user_id": "'$USER_ID'"
}'

CREATE_ORDER_STATUS_RESPONSE=$(grpcurl -d "$CREATE_ORDER_STATUS_REQUEST" -plaintext "$ORDER_STATUS_SERVICE" OrderStatusService/CreateOrderStatus)

echo "CreateOrderStatus response: $CREATE_ORDER_STATUS_RESPONSE"

EXPECTED_STATUS="CREATED"
ACTUAL_STATUS=$(echo "$CREATE_ORDER_STATUS_RESPONSE" | jq -r '.status')

if [ "$ACTUAL_STATUS" == "CREATED" ]; then
  echo "Test passed: Order status matches."
else
  echo "Test failed: Expected status '$EXPECTED_STATUS', but got '$ACTUAL_STATUS'."
fi

echo "Test 6: OrderStatusService/UpdateOrderStatus"

UPDATE_ORDER_STATUS_REQUEST='{
  "order_id": "'$ORDER_ID'",
  "status": "COMPLETED"
}'

UPDATE_ORDER_STATUS_RESPONSE=$(grpcurl -d "$UPDATE_ORDER_STATUS_REQUEST" -plaintext "$ORDER_STATUS_SERVICE" OrderStatusService/UpdateOrderStatus)

echo "UpdateOrderStatus response: $UPDATE_ORDER_STATUS_RESPONSE"

EXPECTED_STATUS="COMPLETED"
ACTUAL_STATUS=$(echo "$UPDATE_ORDER_STATUS_RESPONSE" | jq -r '.status')

if [ "$ACTUAL_STATUS" == "COMPLETED" ]; then
  echo "Test passed: Order status matches."
else
  echo "Test failed: Expected status '$EXPECTED_STATUS', but got '$ACTUAL_STATUS'."
fi

echo "Test 7: OrderStatusService/GetOrderStatus"

GET_ORDER_STATUS_REQUEST='{
  "order_id": "'"$ORDER_ID"'"
}'

GET_ORDER_STATUS_RESPONSE=$(grpcurl -d "$GET_ORDER_STATUS_REQUEST" -plaintext "$ORDER_STATUS_SERVICE" OrderStatusService/GetOrderStatus)

echo "GetOrderStatus response: $GET_ORDER_STATUS_RESPONSE"

EXPECTED_STATUS="COMPLETED"
ACTUAL_STATUS=$(echo "$GET_ORDER_STATUS_RESPONSE" | jq -r '.status')

if [ "$ACTUAL_STATUS" == "$EXPECTED_STATUS" ]; then
  echo "Test passed: Order status matches."
else
  echo "Test failed: Expected status '$EXPECTED_STATUS', but got '$ACTUAL_STATUS'."
fi

echo "Test 8: PaymentService/ProcessPayment"

PROCESS_PAYMENT_REQUEST='{
  "order_id": "'"$ORDER_ID"'",
  "user_id": "'$USER_ID'",
  "amount": 100.0
}'

PROCESS_PAYMENT_RESPONSE=$(grpcurl -d "$PROCESS_PAYMENT_REQUEST" -plaintext "$PAYMENT_SERVICE" PaymentService/ProcessPayment)

echo "ProcessPayment response: $PROCESS_PAYMENT_RESPONSE"

PAYMENT_ID=$(echo "$PROCESS_PAYMENT_RESPONSE" | jq -r '.payment_id')

if [ -z "$PAYMENT_ID" ]; then
  echo "Test failed: The payment was not processed or the payment_id was not get."
  exit 1
  else
  echo "Test passed: Payment processed successfully with payment_id: $PAYMENT_ID"
fi

echo "Test 9: ReviewService/LeaveReview"

LEAVE_REVIEW_REQUEST='{
  "user_id": "'$USER_ID'",
  "product_id": "'$PRODUCT_ID'",
  "review_text": "Excellent service!",
  "rating": 5
}'

LEAVE_REVIEW_RESPONSE=$(grpcurl -d "$LEAVE_REVIEW_REQUEST" -plaintext "$REVIEW_SERVICE" ReviewService/LeaveReview)

echo "LeaveReview response: $LEAVE_REVIEW_RESPONSE"

REVIEW_ID=$(echo "$LEAVE_REVIEW_RESPONSE" | jq -r '.review_id')

if [ -z "$REVIEW_ID" ]; then
  echo "Test failed: The review was not leaved or the review_id was not get."
  exit 1
  else
  echo "Test passed: Review leaved successfully with review_id: $REVIEW_ID"
fi

echo "All tests completed."
