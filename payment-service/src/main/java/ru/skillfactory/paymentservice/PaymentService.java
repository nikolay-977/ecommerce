package ru.skillfactory.paymentservice;

import io.grpc.stub.StreamObserver;
import net.devh.boot.grpc.server.service.GrpcService;

import java.util.HashMap;
import java.util.UUID;

@GrpcService
public class PaymentService extends PaymentServiceGrpc.PaymentServiceImplBase {

    private static final HashMap<String, PaymentResponse> payments = new HashMap<>();

    @Override
    public void processPayment(ProcessPaymentRequest request, StreamObserver<PaymentResponse> responseObserver) {

        String paymentId = UUID.randomUUID().toString();

        PaymentResponse response = PaymentResponse.newBuilder()
                .setOrderId(request.getOrderId())
                .setPaymentId(paymentId)
                .setSuccess(true)
                .setMessage("Оплачено: " + request.getAmount())
                .build();

        payments.put(paymentId, response);

        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }
}
