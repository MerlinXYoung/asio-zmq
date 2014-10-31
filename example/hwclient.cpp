#include <functional>
#include <iostream>
#include <iterator>
#include <vector>
#include <boost/asio.hpp>
#include <asio-zmq.hpp>

static std::string const req = "Hello";

class hwclient {
private:
    boost::asio::zmq::socket socket_;
    std::vector<boost::asio::zmq::frame> buffer_;
    int request_nbr_;

public:
    hwclient(boost::asio::io_service& io, boost::asio::zmq::context& ctx)
        : socket_(io, ctx, ZMQ_REQ), buffer_(), request_nbr_(0)
    {
    }

    void start()
    {
        socket_.connect("tcp://localhost:5555");

        buffer_.push_back(boost::asio::zmq::frame(req));

        std::cout << "Sending Hello " << request_nbr_ << "...\n";
        socket_.async_write_message(
            std::begin(buffer_), std::end(buffer_),
            std::bind(&hwclient::handle_write, this, std::placeholders::_1));
    }

    void handle_write(boost::system::error_code const& ec)
    {
        buffer_.clear();
        socket_.async_read_message(std::back_inserter(buffer_),
                                   std::bind(&hwclient::handle_read, this, std::placeholders::_1));
    }

    void handle_read(boost::system::error_code const& ec)
    {
        std::cout << "Received World " << request_nbr_ << "\n";
        if (++request_nbr_ == 10) return;

        buffer_.clear();
        buffer_.push_back(boost::asio::zmq::frame(req));
        std::cout << "Sending Hello " << request_nbr_ << "...\n";
        socket_.async_write_message(
            std::begin(buffer_), std::end(buffer_),
            std::bind(&hwclient::handle_write, this, std::placeholders::_1));
    }
};

int main()
{
    boost::asio::io_service ios;
    boost::asio::zmq::context ctx;
    hwclient client(ios, ctx);

    client.start();

    ios.run();

    return 0;
}
