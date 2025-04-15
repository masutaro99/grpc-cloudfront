package main

import (
    "context"
    "log"
    "net"

    "google.golang.org/grpc"
    "google.golang.org/grpc/reflection"
    "google.golang.org/grpc/codes"
    "google.golang.org/grpc/status"

    pb "google.golang.org/grpc/examples/helloworld/helloworld"
)

type server struct{
    pb.UnimplementedGreeterServer
}

func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	  log.Printf("Received: %v", in.Name)

    // 入力値の検証
    if in.Name == "" {
        return nil, status.Error(codes.InvalidArgument, "名前が空です。有効な名前を指定してください")
    }

	return &pb.HelloReply{Message: "Hello " + in.Name}, nil
}
func main() {
    lis, err := net.Listen("tcp", ":50051")
    if err != nil {
        log.Fatalf("failed to listen: %v", err)
    }
    s := grpc.NewServer()
    pb.RegisterGreeterServer(s, &server{})
    reflection.Register(s)
    log.Printf("serving on :50051\n")
    if err := s.Serve(lis); err != nil {
        log.Fatalf("failed to serve: %v", err)
    }
}
