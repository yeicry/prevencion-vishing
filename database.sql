-- Create the Vishing Prevention Database
CREATE DATABASE VishingPrevention;
GO

USE VishingPrevention;
GO

-- Users Table
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL, -- Would be hashed in production
    Phone NVARCHAR(20),
    Address NVARCHAR(255),
    City NVARCHAR(50),
    Province NVARCHAR(50),
    PostalCode NVARCHAR(10),
    UserRole NVARCHAR(20) DEFAULT 'student', -- student, instructor, admin
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    LastLogin DATETIME NULL
);

-- Courses Table
CREATE TABLE Courses (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    Duration NVARCHAR(50), -- e.g., "2 hours", "5 hours"
    Level NVARCHAR(20), -- Basic, Intermediate, Advanced
    Price DECIMAL(10, 2) DEFAULT 0.00,
    IsFeatured BIT DEFAULT 0,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL
);

-- Course Modules Table
CREATE TABLE CourseModules (
    ModuleID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    OrderNumber INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Course Lessons Table
CREATE TABLE CourseLessons (
    LessonID INT IDENTITY(1,1) PRIMARY KEY,
    ModuleID INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    Content NVARCHAR(MAX),
    VideoURL NVARCHAR(255),
    Duration INT, -- in minutes
    OrderNumber INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,
    FOREIGN KEY (ModuleID) REFERENCES CourseModules(ModuleID)
);

-- Enrollments Table
CREATE TABLE Enrollments (
    EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollmentDate DATETIME DEFAULT GETDATE(),
    CompletionDate DATETIME NULL,
    IsCompleted BIT DEFAULT 0,
    Certificate NVARCHAR(255) NULL, -- Path to certificate file
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- User Progress Table
CREATE TABLE UserProgress (
    ProgressID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    LessonID INT NOT NULL,
    IsCompleted BIT DEFAULT 0,
    CompletionDate DATETIME NULL,
    LastAccessDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (LessonID) REFERENCES CourseLessons(LessonID)
);

-- Quizzes Table
CREATE TABLE Quizzes (
    QuizID INT IDENTITY(1,1) PRIMARY KEY,
    LessonID INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    PassingScore INT DEFAULT 70, -- Percentage
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,
    FOREIGN KEY (LessonID) REFERENCES CourseLessons(LessonID)
);

-- Quiz Questions Table
CREATE TABLE QuizQuestions (
    QuestionID INT IDENTITY(1,1) PRIMARY KEY,
    QuizID INT NOT NULL,
    QuestionText NVARCHAR(MAX) NOT NULL,
    QuestionType NVARCHAR(20) NOT NULL, -- multiple-choice, true-false, etc.
    OrderNumber INT NOT NULL,
    FOREIGN KEY (QuizID) REFERENCES Quizzes(QuizID)
);

-- Quiz Answers Table
CREATE TABLE QuizAnswers (
    AnswerID INT IDENTITY(1,1) PRIMARY KEY,
    QuestionID INT NOT NULL,
    AnswerText NVARCHAR(MAX) NOT NULL,
    IsCorrect BIT DEFAULT 0,
    OrderNumber INT NOT NULL,
    FOREIGN KEY (QuestionID) REFERENCES QuizQuestions(QuestionID)
);

-- User Quiz Attempts Table
CREATE TABLE UserQuizAttempts (
    AttemptID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    QuizID INT NOT NULL,
    Score INT NOT NULL,
    IsPassed BIT DEFAULT 0,
    AttemptDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (QuizID) REFERENCES Quizzes(QuizID)
);

-- User Quiz Answers Table
CREATE TABLE UserQuizAnswers (
    UserAnswerID INT IDENTITY(1,1) PRIMARY KEY,
    AttemptID INT NOT NULL,
    QuestionID INT NOT NULL,
    AnswerID INT NULL,
    UserAnswerText NVARCHAR(MAX) NULL, -- For open-ended questions
    IsCorrect BIT DEFAULT 0,
    FOREIGN KEY (AttemptID) REFERENCES UserQuizAttempts(AttemptID),
    FOREIGN KEY (QuestionID) REFERENCES QuizQuestions(QuestionID),
    FOREIGN KEY (AnswerID) REFERENCES QuizAnswers(AnswerID)
);

-- Vishing Reports Table
CREATE TABLE VishingReports (
    ReportID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NULL, -- Can be NULL for anonymous reports
    ReporterName NVARCHAR(100) NOT NULL,
    ReporterEmail NVARCHAR(100) NOT NULL,
    ReporterPhone NVARCHAR(20),
    IncidentDate DATETIME NOT NULL,
    CallerNumber NVARCHAR(20),
    CallerOrganization NVARCHAR(100),
    IncidentDescription NVARCHAR(MAX) NOT NULL,
    ActionTaken NVARCHAR(MAX),
    Status NVARCHAR(20) DEFAULT 'Pending', -- Pending, Investigating, Resolved, Closed
    ReportDate DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Resources Table (Articles, PDFs, etc.)
CREATE TABLE Resources (
    ResourceID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    ResourceType NVARCHAR(20) NOT NULL, -- article, pdf, infographic, etc.
    ContentURL NVARCHAR(255) NOT NULL,
    ThumbnailURL NVARCHAR(255),
    IsPublished BIT DEFAULT 1,
    PublishedDate DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL
);

-- Videos Table
CREATE TABLE Videos (
    VideoID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    VideoURL NVARCHAR(255) NOT NULL,
    ThumbnailURL NVARCHAR(255),
    Duration INT, -- in seconds
    Category NVARCHAR(50), -- educational, testimonial, etc.
    IsPublished BIT DEFAULT 1,
    PublishedDate DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL
);

-- Contact Messages Table
CREATE TABLE ContactMessages (
    MessageID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    Subject NVARCHAR(100) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    IsRead BIT DEFAULT 0,
    MessageDate DATETIME DEFAULT GETDATE(),
    ResponseDate DATETIME NULL,
    ResponseMessage NVARCHAR(MAX) NULL
);

-- Newsletter Subscribers Table
CREATE TABLE NewsletterSubscribers (
    SubscriberID INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    SubscriptionDate DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    UnsubscribeDate DATETIME NULL
);

-- Testimonials Table
CREATE TABLE Testimonials (
    TestimonialID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NULL, -- Can be NULL for external testimonials
    Name NVARCHAR(100) NOT NULL,
    Organization NVARCHAR(100),
    Content NVARCHAR(MAX) NOT NULL,
    Rating INT, -- 1-5 stars
    IsApproved BIT DEFAULT 0,
    SubmissionDate DATETIME DEFAULT GETDATE(),
    ApprovalDate DATETIME NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- FAQ Categories Table
CREATE TABLE FAQCategories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX),
    OrderNumber INT NOT NULL
);

-- FAQs Table
CREATE TABLE FAQs (
    FAQID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT NOT NULL,
    Question NVARCHAR(255) NOT NULL,
    Answer NVARCHAR(MAX) NOT NULL,
    OrderNumber INT NOT NULL,
    IsPublished BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,
    FOREIGN KEY (CategoryID) REFERENCES FAQCategories(CategoryID)
);

-- Statistics Table
CREATE TABLE VishingStatistics (
    StatID INT IDENTITY(1,1) PRIMARY KEY,
    StatName NVARCHAR(100) NOT NULL,
    StatValue NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX),
    Period NVARCHAR(50), -- e.g., "Q1 2025", "January 2025"
    Source NVARCHAR(100),
    IsPublished BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL
);

-- Insert sample data for Courses
INSERT INTO Courses (Title, Description, Duration, Level, Price, IsFeatured)
VALUES 
('Fundamentos de Seguridad Telefónica', 'Aprende los conceptos básicos para identificar llamadas sospechosas y proteger tu información personal.', '2 horas', 'Básico', 0.00, 1),
('Técnicas Avanzadas Anti-Vishing', 'Estrategias avanzadas para protegerte del vishing y reconocer técnicas de manipulación psicológica.', '5 horas', 'Intermedio', 1500.00, 1),
('Certificación en Seguridad Digital', 'Curso completo de seguridad digital que incluye protección contra vishing, phishing y otras amenazas.', '10 horas', 'Avanzado', 3000.00, 1);

-- Insert sample data for FAQ Categories
INSERT INTO FAQCategories (Name, Description, OrderNumber)
VALUES 
('General', 'Preguntas generales sobre vishing', 1),
('Prevención', 'Cómo prevenir el vishing', 2),
('Cursos', 'Preguntas sobre nuestros cursos', 3);

-- Insert sample data for FAQs
INSERT INTO FAQs (CategoryID, Question, Answer, OrderNumber, IsPublished)
VALUES 
(1, '¿Qué es el vishing?', 'El vishing (combinación de "voice" y "phishing") es una forma de estafa donde los delincuentes utilizan llamadas telefónicas para engañar a las personas y obtener información personal o financiera.', 1, 1),
(1, '¿Cómo puedo saber si estoy siendo víctima de vishing?', 'Algunas señales de alerta incluyen: llamadas no solicitadas que piden información personal, sensación de urgencia, amenazas, solicitud de pagos inmediatos, o números de teléfono sospechosos.', 2, 1),
(2, '¿Qué debo hacer si recibo una llamada sospechosa?', 'Cuelga inmediatamente. No proporciones ninguna información personal. Si la llamada supuestamente proviene de tu banco u otra institución, cuelga y llama directamente al número oficial.', 1, 1),
(2, '¿Los bancos solicitan información personal por teléfono?', 'Los bancos nunca solicitan datos completos de tarjetas, contraseñas o códigos de seguridad por teléfono. Si alguien te pide esta información, es una estafa.', 2, 1),
(3, '¿Los cursos incluyen certificación?', 'Sí, todos nuestros cursos incluyen un certificado de finalización. Los cursos de nivel intermedio y avanzado incluyen certificaciones reconocidas por la Universidad O&M.', 1, 1),
(3, '¿Puedo acceder a los cursos desde mi teléfono móvil?', 'Sí, nuestra plataforma es completamente responsiva y puedes acceder a todos los contenidos desde cualquier dispositivo con conexión a internet.', 2, 1);

-- Insert sample data for Vishing Statistics
INSERT INTO VishingStatistics (StatName, StatValue, Description, Period, Source)
VALUES 
('Aumento de casos', '45%', 'Incremento en casos reportados de vishing en República Dominicana', 'Primer semestre 2025', 'Instituto Dominicano de las Telecomunicaciones'),
('Dominicanos afectados', '5,000+', 'Número estimado de dominicanos afectados por vishing', 'Primer semestre 2025', 'Policía Nacional'),
('Estudiantes capacitados', '3,200+', 'Estudiantes que han completado nuestros cursos de prevención', 'Primer semestre 2025', 'Universidad O&M'),
('Tasa de prevención', '95%', 'Porcentaje de estudiantes que han evitado ser víctimas después de tomar nuestros cursos', 'Primer semestre 2025', 'Encuesta interna Universidad O&M');