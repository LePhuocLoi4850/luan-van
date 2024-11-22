CREATE TABLE auth (
    auth_id SERIAL PRIMARY KEY,           -- Khóa chính tự động tăng
    name VARCHAR(100) NOT NULL,           -- Tên người dùng, tối đa 100 ký tự, không cho phép NULL
    email VARCHAR(255) UNIQUE NOT NULL,   -- Email người dùng, tối đa 255 ký tự, duy nhất, không cho phép NULL
    pass VARCHAR(255) NOT NULL,           -- Mật khẩu đã băm, tối đa 255 ký tự, không cho phép NULL
    created_at TIMESTAMP DEFAULT NOW()    -- Thời gian tạo tài khoản, mặc định là thời gian hiện tại
);
CREATE TABLE calender (
    cld_id SERIAL PRIMARY KEY , -- Khóa chính
    cid INT,                               -- Khóa ngoại
    name VARCHAR(255) NOT NULL,            -- Tên
    time VARCHAR(255) NOT NULL,                -- Thời gian
    address VARCHAR(255) NOT NULL,         -- Địa chỉ
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Thời điểm tạo
    FOREIGN KEY (cid) REFERENCES company(cid) -- Thay another_table bằng tên bảng có khóa chính cid
);
CREATE TABLE favorites (
  	uid INT,
  	jid INT, 
	cid INT,
	title VARCHAR(255) NOT NULL,
	nameC VARCHAR(255) NOT NULL,
	addressC VARCHAR(255) NOT NULL,
	experienceJ VARCHAR(255) NOT NULL,
	salary_fromJ VARCHAR(255) NOT NULL,
	salary_toJ VARCHAR(255) NOT NULL,
	imageC TEXT,
  	create_at TIMESTAMP,
  FOREIGN KEY (uid) REFERENCES users(uid),
  FOREIGN KEY (jid) REFERENCES job(jid),
	FOREIGN KEY (cid) REFERENCES company(cid),
  UNIQUE (uid, jid, cid)
);
CREATE TABLE cvprofile (
      cvp_id SERIAL PRIMARY KEY,              -- Khóa chính tự động tăng
    uid INT,                                 -- ID công việc (khóa ngoại đến bảng job)
    certi_id INT,                                 -- ID người dùng (khóa ngoại đến bảng users)
    edu_id INT,                                 -- ID công ty (khóa ngoại đến bảng company)
	expe_id INT,
	skill_id INT,
    
    -- Ràng buộc khóa ngoại
    CONSTRAINT fk_users
      FOREIGN KEY (uid) 
      REFERENCES users (uid)
      ON DELETE CASCADE,                     -- Xóa công việc sẽ xóa các đơn ứng tuyển liên quan

    CONSTRAINT fk_certificate
      FOREIGN KEY (certi_id) 
      REFERENCES certificate (certi_id)
      ON DELETE CASCADE,                     -- Xóa người dùng sẽ xóa các đơn ứng tuyển liên quan

    CONSTRAINT fk_education
      FOREIGN KEY (edu_id) 
      REFERENCES education (edu_id)
      ON DELETE CASCADE,                      -- Xóa công ty sẽ xóa các đơn ứng tuyển liên quan
	
    CONSTRAINT fk_experience
      FOREIGN KEY (expe_id) 
      REFERENCES experience (expe_id)
      ON DELETE CASCADE,
	
	 CONSTRAINT fk_skill
      FOREIGN KEY (skill_id) 
      REFERENCES skill (skill_id)
      ON DELETE CASCADE
);

CREATE TABLE education (
    edu_id SERIAL PRIMARY KEY,           -- Khóa chính tự động tăng
	uid INT,
    level VARCHAR(100) NOT NULL,           -- Tên người dùng, tối đa 100 ký tự, không cho phép NULL
    name VARCHAR(255) NOT NULL,  
    time_from Date NOT NULL,          
    time_to Date NOT NULL,  
	description TEXT, 
	 CONSTRAINT fk_users
      FOREIGN KEY (uid) 
      REFERENCES users (uid)
      ON DELETE CASCADE     
);
CREATE TABLE experience (
    expe_id SERIAL PRIMARY KEY,           -- Khóa chính tự động tăng
	uid INT,
    namecompany VARCHAR(100) NOT NULL,           -- Tên người dùng, tối đa 100 ký tự, không cho phép NULL
    position VARCHAR(255) NOT NULL,  
    time_from Date NOT NULL,          
    time_to Date NOT NULL,  
	description TEXT, 
	 CONSTRAINT fk_users
      FOREIGN KEY (uid) 
      REFERENCES users (uid)
      ON DELETE CASCADE     
);
CREATE TABLE certificate (
    certi_id SERIAL PRIMARY KEY,           -- Khóa chính tự động tăng
	uid INT,
    namecertificate VARCHAR(100) NOT NULL,           -- Tên người dùng, tối đa 100 ký tự, không cho phép NULL
    namehost VARCHAR(255) NOT NULL,  
    time_from Date NOT NULL,          
    time_to Date NOT NULL,  
	description TEXT, 
	 CONSTRAINT fk_users
      FOREIGN KEY (uid) 
      REFERENCES users (uid)
      ON DELETE CASCADE     
);
CREATE TABLE skill (
    skill_id SERIAL PRIMARY KEY,           -- Khóa chính tự động tăng
	uid INT,
    name VARCHAR(100) NOT NULL,           -- Tên người dùng, tối đa 100 ký tự, không cho phép NULL
	rating INT,

	 CONSTRAINT fk_users
      FOREIGN KEY (uid) 
      REFERENCES users (uid)
      ON DELETE CASCADE     
);
CREATE TABLE mycv (
    cv_id SERIAL PRIMARY KEY,           -- Khóa chính tự động tăng
	uid INT,
    pdf TEXT,

	 CONSTRAINT fk_users
      FOREIGN KEY (uid) 
      REFERENCES users (uid)
      ON DELETE CASCADE     
);
 CREATE TABLE company (
    cid SERIAL PRIMARY KEY,                  -- Khóa chính, tự động tăng
    name VARCHAR(255) NOT NULL,             -- Tên người dùng, tối đa 255 ký tự
    email VARCHAR(255) UNIQUE NOT NULL,     -- Email, duy nhất và không cho phép NULL
    career VARCHAR(255),                    -- Nghề nghiệp
    phone VARCHAR(20),                      -- Số điện thoại, tối đa 20 ký tự
    address VARCHAR(255),    				 -- Địa chỉ
	scale VARCHAR(255),							-- Quy mô công ty
    description TEXT,                       -- Mô tả về bản thân (không giới hạn chiều dài)
    image TEXT,                             -- Hình ảnh, có thể là link hoặc base64
    created_at TIMESTAMP DEFAULT NOW()      -- Thời gian tạo tài khoản, mặc định là thời gian hiện tại
);

CREATE TABLE job (
    jid SERIAL PRIMARY KEY,              -- Khóa chính tự động tăng
    cid INT,                             -- Khóa ngoại liên kết với bảng company
    title VARCHAR(255) NOT NULL,         -- Tiêu đề công việc
    career VARCHAR(255),                 -- Nghề nghiệp
    type VARCHAR(100),                   -- Loại công việc (full-time, part-time, etc.)
    quantity INT,                        -- Số lượng tuyển dụng
    gender VARCHAR(10),                  -- Giới tính yêu cầu
    salary_from VARCHAR(100),            -- Mức lương tối thiểu (String)
    salary_to VARCHAR(100),              -- Mức lương tối đa (String)
    experience VARCHAR(255),             -- Kinh nghiệm yêu cầu
    working_time VARCHAR(255),                   -- Thời gian làm việc (ví dụ: toàn thời gian, bán thời gian)
    description TEXT,                    -- Mô tả công việc
    request TEXT,                        -- Yêu cầu công việc
    interest TEXT,                       -- Quyền lợi công việc
	expiration_date DATE,
	status BOOLEAN,
    CONSTRAINT fk_company
      FOREIGN KEY (cid) 
      REFERENCES company (cid)
      ON DELETE CASCADE                  -- Xóa công ty sẽ xóa các công việc liên quan
);
CREATE TABLE apply (
    apply_id SERIAL PRIMARY KEY,             -- Khóa chính tự động tăng
    jid INT,                                 -- ID công việc (khóa ngoại đến bảng job)
    uid INT,                                 -- ID người dùng (khóa ngoại đến bảng users)
    cid INT,                                 -- ID công ty (khóa ngoại đến bảng company)
	nameu VARCHAR(255),						  -- Tên ứng viên
    title VARCHAR(255),                      -- Tiêu đề công việc
    namec VARCHAR(255),                      -- Tên công ty
    address VARCHAR(255),                    -- Địa chỉ ứng viên hoặc công ty
    experience TEXT,                         -- Kinh nghiệm của ứng viên
    salary_from VARCHAR(100),                -- Mức lương tối thiểu
    salary_to VARCHAR(100),                  -- Mức lương tối đa
    apply_date TIMESTAMP DEFAULT NOW(),      -- Ngày ứng tuyển, mặc định là thời gian hiện tại
    status VARCHAR(50) DEFAULT 'Pending',    -- Trạng thái đơn ứng tuyển (Pending, Accepted, Rejected)
    imagec TEXT,
    imageu TEXT,
	cv_id int,
	namecv VARCHAR(255),
    -- Ràng buộc khóa ngoại
    CONSTRAINT fk_job
      FOREIGN KEY (jid) 
      REFERENCES job (jid)
      ON DELETE CASCADE,                     -- Xóa công việc sẽ xóa các đơn ứng tuyển liên quan

    CONSTRAINT fk_user
      FOREIGN KEY (uid) 
      REFERENCES users (uid)
      ON DELETE CASCADE,                     -- Xóa người dùng sẽ xóa các đơn ứng tuyển liên quan

    CONSTRAINT fk_company
      FOREIGN KEY (cid) 
      REFERENCES company (cid)
      ON DELETE CASCADE,                      -- Xóa công ty sẽ xóa các đơn ứng tuyển liên quan
	CONSTRAINT fk_mycv
      FOREIGN KEY (cv_id) 
      REFERENCES mycv (cv_id)
      ON DELETE CASCADE  
);

-- bảng củ
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
	salary from 
	salary to 
    image TEXT,                             -- Hình ảnh, có thể là link hoặc base64
   
    experience TEXT,                        -- Kinh nghiệm làm việc
  
    created_at TIMESTAMP DEFAULT NOW()      -- Thời gian tạo tài khoản, mặc định là thời gian hiện tại
);
-- bảng mới
CREATE TABLE users_new (
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
-- chuyển dữ liệu từ bảng củ sang bảng mới
INSERT INTO users_new (uid, email, name, career, phone, gender, birthday, address, description, image, education, skill, certificate, experience, prize, created_at)
SELECT uid, email, name, career, phone, gender, birthday, address, description, image, education, skill, certificate, experience, prize, created_at
FROM users;


-- CREATE EXTENSION pg_cron tự động thay đổi status khi job hết hạn