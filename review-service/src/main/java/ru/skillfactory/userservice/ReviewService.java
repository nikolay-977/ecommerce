package ru.skillfactory.userservice;

import io.grpc.stub.StreamObserver;
import net.devh.boot.grpc.server.service.GrpcService;
import ru.skillfactory.reviewservice.LeaveReviewRequest;
import ru.skillfactory.reviewservice.ReviewResponse;
import ru.skillfactory.reviewservice.ReviewServiceGrpc;

import java.util.HashMap;
import java.util.UUID;

@GrpcService
public class ReviewService extends ReviewServiceGrpc.ReviewServiceImplBase {

    private static final HashMap<String, ReviewResponse> reviews = new HashMap<>();

    @Override
    public void leaveReview(LeaveReviewRequest request, StreamObserver<ReviewResponse> responseObserver) {
        String reviewId = UUID.randomUUID().toString();

        ReviewResponse response = ReviewResponse.newBuilder()
                .setReviewId(reviewId)
                .setUserId(request.getUserId())
                .setProductId(request.getProductId())
                .setReviewText(request.getReviewText())
                .setRating(request.getRating())
                .build();

        reviews.put(reviewId, response);

        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }
}
