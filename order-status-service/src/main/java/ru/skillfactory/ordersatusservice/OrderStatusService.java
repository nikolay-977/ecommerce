package ru.skillfactory.ordersatusservice;

import io.grpc.stub.StreamObserver;
import net.devh.boot.grpc.server.service.GrpcService;
import ru.skillfactory.orderstatusservice.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.UUID;

@GrpcService
public class OrderStatusService extends OrderStatusServiceGrpc.OrderStatusServiceImplBase {

    private static final HashMap<String, OrderStatusResponse> ordersStatus = new HashMap<>();

    @Override
    public void createOrderStatus(CreateOrderStatusRequest request, StreamObserver<OrderStatusResponse> responseObserver) {
        String orderId = UUID.randomUUID().toString();

        OrderStatusResponse response = OrderStatusResponse.newBuilder()
                .setOrderId(orderId)
                .setStatus("CREATED")
                .build();

        ordersStatus.put(orderId, response);

        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void updateOrderStatus(UpdateOrderStatusRequest request, StreamObserver<OrderStatusResponse> responseObserver) {

        OrderStatusResponse orderStatusResponse = OrderStatusResponse.newBuilder()
                .setOrderId(request.getOrderId())
                .setStatus(request.getStatus())
                .build();

        ordersStatus.remove(request.getOrderId());
        ordersStatus.put(request.getOrderId(), orderStatusResponse);

        responseObserver.onNext(orderStatusResponse);
        responseObserver.onCompleted();
    }

    @Override
    public void getOrderStatus(GetOrderStatusRequest request, StreamObserver<OrderStatusResponse> responseObserver) {
        OrderStatusResponse orderStatus = ordersStatus.get(request.getOrderId());

        responseObserver.onNext(orderStatus);
        responseObserver.onCompleted();
    }
}
