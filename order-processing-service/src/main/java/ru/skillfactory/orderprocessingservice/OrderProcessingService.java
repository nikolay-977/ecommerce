package ru.skillfactory.orderprocessingservice;

import io.grpc.stub.StreamObserver;
import net.devh.boot.grpc.server.service.GrpcService;
import org.springframework.core.annotation.Order;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@GrpcService
public class OrderProcessingService extends OrderProcessingServiceGrpc.OrderProcessingServiceImplBase {

    private static final Map<String, OrderResponse> orders = new HashMap<>();

    @Override
    public void createOrder(CreateOrderRequest request, StreamObserver<OrderResponse> responseObserver) {
        String orderId = UUID.randomUUID().toString();

        OrderResponse response = OrderResponse.newBuilder()
                .setOrderId(orderId)
                .setUserId(request.getUserId())
                .build();

        orders.put(orderId, response);

        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void getOrder(GetOrderRequest request, StreamObserver<OrderResponse> responseObserver) {
        OrderResponse response = orders.get(request.getOrderId());

        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }
}
