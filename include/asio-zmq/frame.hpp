#ifndef ASIO_ZMQ_FRAME_HPP_
#define ASIO_ZMQ_FRAME_HPP_

#include <algorithm>
#include <cstddef>
#include <iterator>
#include <memory>
#include <string>
#include <utility>
#include <zmq.h>
#include "helpers.hpp"
#include "exception.hpp"

namespace asio {
namespace zmq {

class frame {
    friend class socket;

private:
    zmq_msg_t raw_msg_;

public:
    explicit frame(std::size_t size) : raw_msg_()
    {
        if (0 != zmq_msg_init_size(&raw_msg_, size))
            throw exception();
    }

    explicit frame() : raw_msg_()
    {
        if (0 != zmq_msg_init(&raw_msg_))
            throw exception();
    }

    ~frame() {
        zmq_msg_close(&raw_msg_);
    }

    frame(frame&& other) noexcept : raw_msg_()
    {
        zmq_msg_move(&raw_msg_, &other.raw_msg_);
    }

    frame& operator=(frame&& other) noexcept
    {
        zmq_msg_move(&raw_msg_, &other.raw_msg_);
        return *this;
    }
    
    frame(frame const& other) : raw_msg_()
    {
        if (0 != zmq_msg_copy(&raw_msg_,
                              const_cast<zmq_msg_t*>(&other.raw_msg_)))
            throw exception();
    }

    explicit frame(std::string const& str) : frame(str.size())
    {
        std::copy(std::begin(str), std::end(str),
                  static_cast<char*>(data()));
    }

    frame& operator=(frame const& other)
    {
        frame tmp(other);

        zmq_msg_move(&raw_msg_, &tmp.raw_msg_);
        return *this;
    }

    std::size_t size() const noexcept
    {
        return zmq_msg_size(const_cast<zmq_msg_t*>(&raw_msg_));
    }

    void *data() noexcept
    {
        return zmq_msg_data(&raw_msg_);
    }

    const void *data() const noexcept
    {
        return zmq_msg_data(const_cast<zmq_msg_t*>(&raw_msg_));
    }
};

} // namespace zmq
} // namespace asio

namespace std {

std::string to_string(asio::zmq::frame const& frame)
{
    return std::string(static_cast<char const*>(frame.data()), frame.size());
}

}
#endif // ASIO_ZMQ_FRAME_HPP_
