
document.addEventListener('DOMContentLoaded', function() {
    
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;
            
            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - 70, 
                    behavior: 'smooth'
                });
            }
        });
    });

   
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form values
            const name = document.getElementById('name').value;
            const email = document.getElementById('email').value;
            const phone = document.getElementById('phone').value;
            const subject = document.getElementById('subject').value;
            const message = document.getElementById('message').value;
            
        
            alert(`Gracias ${name} por tu mensaje. Te contactaremos pronto.`);
            
            
            contactForm.reset();
        });
    }

    
    const newsletterForm = document.querySelector('footer form');
    if (newsletterForm) {
        newsletterForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const email = this.querySelector('input[type="email"]').value;
            
            
            alert(`Gracias por suscribirte con ${email}. Recibirás nuestro próximo boletín.`);
            
            
            this.reset();
        });
    }

    
    function animateCounters() {
        const counters = document.querySelectorAll('.display-4.fw-bold');
        
        counters.forEach(counter => {
            const target = isNaN(Number(counter.innerText.replace(/[^0-9.-]+/g, ''))) ? 0 : Number(counter.innerText.replace(/[^0-9.-]+/g, ''));
            const duration = 2000; 
            const step = Math.ceil(target / (duration / 20)); 
            
            let current = 0;
            const updateCounter = () => {
                current += step;
                if (current > target) {
                    current = target;
                }
                
                
                let formattedNumber = current.toString();
                if (counter.innerText.includes('%')) {
                    formattedNumber += '%';
                } else if (counter.innerText.includes('+')) {
                    formattedNumber += '+';
                }
                
                counter.innerText = formattedNumber;
                
                if (current < target) {
                    setTimeout(updateCounter, 20);
                }
            };
            
            
            counter.innerText = '0';
            
            
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        updateCounter();
                        observer.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.5 });
            
            observer.observe(counter);
        });
    }
    
    animateCounters();
});


class Database {
    constructor() {
        this.users = [];
        this.courses = [];
        this.enrollments = [];
        this.reports = [];
        this.messages = [];
        
      
        this.initSampleData();
    }
    
    initSampleData() {
        
        this.courses = [
            { id: 1, title: 'Fundamentos de Seguridad Telefónica', duration: '2 horas', price: 0, level: 'Básico' },
            { id: 2, title: 'Técnicas Avanzadas Anti-Vishing', duration: '5 horas', price: 1500, level: 'Intermedio' },
            { id: 3, title: 'Certificación en Seguridad Digital', duration: '10 horas', price: 3000, level: 'Avanzado' }
        ];
    }
    
    
    registerUser(userData) {
        const newUser = {
            id: this.users.length + 1,
            ...userData,
            createdAt: new Date()
        };
        this.users.push(newUser);
        return newUser;
    }
    
    loginUser(email, password) {
        return this.users.find(user => user.email === email && user.password === password);
    }
    
   
    getAllCourses() {
        return this.courses;
    }
    
    getCourseById(id) {
        return this.courses.find(course => course.id === id);
    }
    
  
    enrollUserInCourse(userId, courseId) {
        const enrollment = {
            id: this.enrollments.length + 1,
            userId,
            courseId,
            enrollmentDate: new Date(),
            completed: false
        };
        this.enrollments.push(enrollment);
        return enrollment;
    }
    
    getUserEnrollments(userId) {
        return this.enrollments
            .filter(enrollment => enrollment.userId === userId)
            .map(enrollment => {
                const course = this.getCourseById(enrollment.courseId);
                return { ...enrollment, course };
            });
    }
    

    submitVishingReport(reportData) {
        const newReport = {
            id: this.reports.length + 1,
            ...reportData,
            reportDate: new Date(),
            status: 'Pendiente'
        };
        this.reports.push(newReport);
        return newReport;
    }
    

    submitContactMessage(messageData) {
        const newMessage = {
            id: this.messages.length + 1,
            ...messageData,
            messageDate: new Date(),
            read: false
        };
        this.messages.push(newMessage);
        return newMessage;
    }
}


const db = new Database();


/*
async function connectToDatabase() {
    try {
        // SQL Server connection would be configured here
        const sql = require('mssql');
        const config = {
            user: 'your_username',
            password: 'your_password',
            server: 'your_server',
            database: 'vishing_prevention',
            options: {
                encrypt: true,
                trustServerCertificate: true
            }
        };
        
        await sql.connect(config);
        console.log('Connected to SQL Server database');
        
        // Example query
        const result = await sql.query`SELECT * FROM Courses`;
        console.log(result.recordset);
        
        return sql;
    } catch (err) {
        console.error('Database connection error:', err);
        throw err;
    }
}
*/