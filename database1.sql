CREATE TABLE users (
    uid SERIAL PRIMARY KEY,                  -- Khóa chính, tự động tăng
    email VARCHAR(255) UNIQUE NOT NULL,     -- Email, duy nhất và không cho phép NULL
    name VARCHAR(255) NOT NULL,             -- Tên người dùng, tối đa 255 ký tự
    career VARCHAR(255),                    -- Nghề nghiệp
    phone VARCHAR(20),                      -- Số điện thoại, tối đa 20 ký tự
    gender VARCHAR(10),                     -- Giới tính (Male/Female), tối đa 10 ký tự
    birthday DATE,                          -- Ngày sinh, kiểu DATE
    address VARCHAR(255),                   -- Địa chỉ
    description TEXT,                       -- Mô tả về bản thân (không giới hạn chiều dài)

    salary_from NUMERIC,                    -- Mức lương tối thiểu
    salary_to NUMERIC,                      -- Mức lương tối đa
    image TEXT,                             -- Hình ảnh, có thể là link hoặc base64
                
    experience TEXT,                        -- Kinh nghiệm làm việc
    
    created_at TIMESTAMP DEFAULT NOW()      -- Thời gian tạo tài khoản, mặc định là thời gian hiện tại
);
CREATE TABLE auth (
    auth_id SERIAL PRIMARY KEY,           -- Khóa chính tự động tăng
    name VARCHAR(100) NOT NULL,           -- Tên người dùng, tối đa 100 ký tự, không cho phép NULL
    email VARCHAR(255) UNIQUE NOT NULL,   -- Email người dùng, tối đa 255 ký tự, duy nhất, không cho phép NULL
    pass VARCHAR(255) NOT NULL,           -- Mật khẩu đã băm, tối đa 255 ký tự, không cho phép NULL
    created_at TIMESTAMP DEFAULT NOW()    -- Thời gian tạo tài khoản, mặc định là thời gian hiện tại
);
