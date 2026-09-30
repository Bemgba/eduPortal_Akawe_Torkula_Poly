<%-- 
    Document   : vacancies
    Created on : Feb 25, 2026
    Purpose    : Job Vacancies Landing Page for Job Seekers
    Author: BEMGBA
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <style>
            :root {
                --primary-color: #0c4f24;
                --primary-light: #1b9e3e;
                --primary-dark: #083619;
                --accent-color: #2d91f4;
                --text-dark: #212631;
                --text-muted: #6d7d9c;
                --bg-light: #f9f9f9;
                --card-shadow: 0 4px 20px rgba(12, 79, 36, 0.08);
            }

            body {
                background: var(--bg-light);
                font-family: var(--cui-body-font-family);
            }

            .vacancies-header {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
                color: white;
                padding: 40px 0 60px;
                margin-bottom: -30px;
                position: relative;
            }

            .vacancies-header::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                height: 30px;
                background: var(--bg-light);
                border-radius: 30px 30px 0 0;
            }

            .logo-container {
                text-align: center;
                margin-bottom: 20px;
            }

            .logo-container img {
                max-height: 80px;
                width: auto;
                filter: brightness(0) invert(1);
            }

            .logo-container h1 {
                font-size: 2rem;
                font-weight: 600;
                margin: 15px 0 5px;
            }

            .logo-container p {
                font-size: 1.1rem;
                opacity: 0.95;
                margin: 0;
            }

            .vacancy-card {
                background: white;
                border-radius: 12px;
                box-shadow: var(--card-shadow);
                padding: 25px;
                margin-bottom: 25px;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                border-left: 4px solid var(--primary-color);
            }

            .vacancy-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 30px rgba(12, 79, 36, 0.15);
            }

            .vacancy-title {
                color: var(--primary-color);
                font-size: 1.5rem;
                font-weight: 600;
                margin-bottom: 10px;
            }

            .vacancy-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                margin-bottom: 15px;
            }

            .meta-item {
                display: flex;
                align-items: center;
                gap: 6px;
                color: var(--text-muted);
                font-size: 0.9rem;
            }

            .meta-item i {
                color: var(--primary-light);
            }

            .badge-custom {
                background: var(--primary-light);
                color: white;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 500;
            }

            .section-title {
                color: var(--text-dark);
                font-size: 1rem;
                font-weight: 600;
                margin-top: 15px;
                margin-bottom: 8px;
            }

            .vacancy-content {
                color: var(--text-dark);
                line-height: 1.6;
            }

            .vacancy-content ul {
                padding-left: 20px;
                margin: 8px 0;
            }

            .vacancy-content li {
                margin-bottom: 5px;
            }

            .deadline-badge {
                background: #f9b115;
                color: white;
                padding: 8px 15px;
                border-radius: 8px;
                font-weight: 600;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .deadline-badge.urgent {
                background: #e55353;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0%, 100% {
                    opacity: 1;
                }
                50% {
                    opacity: 0.8;
                }
            }

            .apply-btn {
                background: var(--primary-color);
                color: white;
                padding: 12px 30px;
                border-radius: 8px;
                border: none;
                font-weight: 600;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
            }

            .apply-btn:hover {
                background: var(--primary-dark);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(12, 79, 36, 0.3);
                color: white;
            }

            .no-vacancies {
                text-align: center;
                padding: 60px 20px;
                background: white;
                border-radius: 12px;
                box-shadow: var(--card-shadow);
            }

            .no-vacancies i {
                font-size: 4rem;
                color: var(--text-muted);
                margin-bottom: 20px;
            }

            .pagination {
                margin-top: 30px;
            }

            .page-link {
                color: var(--primary-color);
                border-color: #dbdfe6;
            }

            .page-link:hover {
                background: var(--primary-light);
                border-color: var(--primary-light);
                color: white;
            }

            .page-item.active .page-link {
                background: var(--primary-color);
                border-color: var(--primary-color);
            }

            .filter-section {
                background: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: var(--card-shadow);
                margin-bottom: 30px;
            }

            .search-box {
                position: relative;
            }

            .search-box input {
                padding-left: 40px;
            }

            .search-box i {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: var(--text-muted);
            }
        </style>
        <title>Job Vacancies - <%=settings.fullName%></title>
    </head>
    <body>

        <!-- Header Section -->
        <div class="vacancies-header">
            <div class="container">
                <div class="logo-container">
                    <img src="assets/img/Akawe.png" alt="<%=settings.fullName%> Logo">
                    <h1><%=settings.fullName%></h1>
                    <p>Career Opportunities</p>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="container" style="position: relative; z-index: 1;">

            <!-- Filter Section -->
            <div class="filter-section">
                <div class="row align-items-end">
                    <div class="col-md-6 mb-3 mb-md-0">
                        <label class="form-label">Search Vacancies</label>
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" class="form-control" id="searchInput" placeholder="Search by job title, department...">
                        </div>
                    </div>
                    <div class="col-md-3 mb-3 mb-md-0">
                        <label class="form-label">Department</label>
                        <select class="form-select" id="departmentFilter">
                            <option value="">All Departments</option>
                            <option value="academic">Academic</option>
                            <option value="administrative">Administrative</option>
                            <option value="technical">Technical</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Employment Type</label>
                        <select class="form-select" id="typeFilter">
                            <option value="">All Types</option>
                            <option value="fulltime">Full-time</option>
                            <option value="contract">Contract</option>
                            <option value="parttime">Part-time</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Vacancies List -->
            <div id="vacanciesList">

                <%
                    // TODO: Backend integration - Replace with actual database query
                    // For now, showing sample vacancy structure
                    boolean hasVacancies = true; // This will be determined by backend

                    if (hasVacancies) {
                %>

                <!-- Sample Vacancy Card 1 -->
                <div class="vacancy-card">
                    <div class="d-flex justify-content-between align-items-start flex-wrap gap-3 mb-3">
                        <div>
                            <h2 class="vacancy-title">Senior Lecturer - Computer Science</h2>
                            <div class="vacancy-meta">
                                <span class="meta-item">
                                    <i class="fas fa-briefcase"></i>
                                    <span>JOB-2026-001</span>
                                </span>
                                <span class="meta-item">
                                    <i class="fas fa-building"></i>
                                    <span>School of ICT</span>
                                </span>
                                <span class="badge-custom">Full-time</span>
                                <span class="badge-custom">CONTEDISS II</span>
                            </div>
                        </div>
                        <div class="deadline-badge">
                            <i class="fas fa-calendar-alt"></i>
                            <span>Deadline: March 31, 2026</span>
                        </div>
                    </div>

                    <div class="vacancy-content">
                        <div class="section-title">Responsibilities:</div>
                        <ul>
                            <li>Teach undergraduate and postgraduate courses in Computer Science</li>
                            <li>Conduct research and publish in reputable journals</li>
                            <li>Supervise student projects and theses</li>
                            <li>Participate in departmental and institutional activities</li>
                        </ul>

                        <div class="section-title">Requirements:</div>
                        <ul>
                            <li>Ph.D. in Computer Science or related field</li>
                            <li>Minimum of 5 years teaching experience at tertiary level</li>
                            <li>Strong publication record in peer-reviewed journals</li>
                            <li>Professional certification (e.g., CPN) is an advantage</li>
                        </ul>

                        <div class="section-title">Required Documents:</div>
                        <ul>
                            <li>Comprehensive Curriculum Vitae (CV)</li>
                            <li>Academic Certificates and Transcripts</li>
                            <li>NYSC Discharge Certificate or Exemption Letter</li>
                            <li>Birth Certificate or Declaration of Age</li>
                            <li>Local Government Identification</li>
                            <li>Professional License (if applicable)</li>
                        </ul>
                    </div>

                    <div class="mt-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                        <div class="text-muted small">
                            <i class="fas fa-clock"></i> Posted: February 15, 2026
                        </div>
                        <a href="/job_application?vacancy_id=JOB-2026-001" class="apply-btn">
                            <i class="fas fa-paper-plane me-2"></i>Apply Now
                        </a>
                    </div>
                </div>

                <!-- Sample Vacancy Card 2 -->
                <div class="vacancy-card">
                    <div class="d-flex justify-content-between align-items-start flex-wrap gap-3 mb-3">
                        <div>
                            <h2 class="vacancy-title">Administrative Officer</h2>
                            <div class="vacancy-meta">
                                <span class="meta-item">
                                    <i class="fas fa-briefcase"></i>
                                    <span>JOB-2026-002</span>
                                </span>
                                <span class="meta-item">
                                    <i class="fas fa-building"></i>
                                    <span>Registry Department</span>
                                </span>
                                <span class="badge-custom">Full-time</span>
                                <span class="badge-custom">CONPCASS 08</span>
                            </div>
                        </div>
                        <div class="deadline-badge urgent">
                            <i class="fas fa-calendar-alt"></i>
                            <span>Deadline: March 10, 2026</span>
                        </div>
                    </div>

                    <div class="vacancy-content">
                        <div class="section-title">Responsibilities:</div>
                        <ul>
                            <li>Manage administrative operations and correspondence</li>
                            <li>Coordinate meetings and maintain records</li>
                            <li>Provide support to senior management</li>
                            <li>Handle student and staff inquiries</li>
                        </ul>

                        <div class="section-title">Requirements:</div>
                        <ul>
                            <li>Bachelor's degree in Business Administration or related field</li>
                            <li>Minimum of 3 years relevant experience</li>
                            <li>Excellent communication and organizational skills</li>
                            <li>Proficiency in MS Office Suite</li>
                        </ul>

                        <div class="section-title">Required Documents:</div>
                        <ul>
                            <li>Comprehensive Curriculum Vitae (CV)</li>
                            <li>Academic Certificates</li>
                            <li>NYSC Discharge Certificate or Exemption Letter</li>
                            <li>Birth Certificate or Declaration of Age</li>
                            <li>Local Government Identification</li>
                        </ul>
                    </div>

                    <div class="mt-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                        <div class="text-muted small">
                            <i class="fas fa-clock"></i> Posted: February 20, 2026
                        </div>
                        <a href="/job_application?vacancy_id=JOB-2026-002" class="apply-btn">
                            <i class="fas fa-paper-plane me-2"></i>Apply Now
                        </a>
                    </div>
                </div>

                <!-- Sample Vacancy Card 3 -->
                <div class="vacancy-card">
                    <div class="d-flex justify-content-between align-items-start flex-wrap gap-3 mb-3">
                        <div>
                            <h2 class="vacancy-title">Laboratory Technologist</h2>
                            <div class="vacancy-meta">
                                <span class="meta-item">
                                    <i class="fas fa-briefcase"></i>
                                    <span>JOB-2026-003</span>
                                </span>
                                <span class="meta-item">
                                    <i class="fas fa-building"></i>
                                    <span>Science Laboratory</span>
                                </span>
                                <span class="badge-custom">Contract</span>
                                <span class="badge-custom">CONTEDISS I</span>
                            </div>
                        </div>
                        <div class="deadline-badge">
                            <i class="fas fa-calendar-alt"></i>
                            <span>Deadline: April 15, 2026</span>
                        </div>
                    </div>

                    <div class="vacancy-content">
                        <div class="section-title">Responsibilities:</div>
                        <ul>
                            <li>Prepare and maintain laboratory equipment and materials</li>
                            <li>Assist in practical sessions and demonstrations</li>
                            <li>Ensure laboratory safety and compliance</li>
                            <li>Maintain laboratory inventory and records</li>
                        </ul>

                        <div class="section-title">Requirements:</div>
                        <ul>
                            <li>HND/B.Sc. in Science Laboratory Technology or related field</li>
                            <li>Minimum of 2 years laboratory experience</li>
                            <li>Knowledge of laboratory safety procedures</li>
                            <li>Professional registration with MLSCN is an advantage</li>
                        </ul>

                        <div class="section-title">Required Documents:</div>
                        <ul>
                            <li>Comprehensive Curriculum Vitae (CV)</li>
                            <li>Academic Certificates</li>
                            <li>NYSC Discharge Certificate or Exemption Letter</li>
                            <li>Birth Certificate or Declaration of Age</li>
                            <li>Local Government Identification</li>
                            <li>Professional License (MLSCN registration if applicable)</li>
                        </ul>
                    </div>

                    <div class="mt-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                        <div class="text-muted small">
                            <i class="fas fa-clock"></i> Posted: February 18, 2026
                        </div>
                        <a href="/job_application?vacancy_id=JOB-2026-003" class="apply-btn">
                            <i class="fas fa-paper-plane me-2"></i>Apply Now
                        </a>
                    </div>
                </div>

                <%
                } else {
                %>

                <!-- No Vacancies Available -->
                <div class="no-vacancies">
                    <i class="fas fa-briefcase"></i>
                    <h3>No Vacancies Available</h3>
                    <p class="text-muted">There are currently no open positions. Please check back later for new opportunities.</p>
                    <a href="/" class="btn btn-outline-primary mt-3">Return to Home</a>
                </div>

                <%
                    }
                %>

            </div>

            <!-- Pagination -->
            <nav aria-label="Vacancies pagination" class="mt-4">
                <ul class="pagination justify-content-center">
                    <li class="page-item disabled">
                        <a class="page-link" href="#" tabindex="-1">Previous</a>
                    </li>
                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                    <li class="page-item">
                        <a class="page-link" href="#">Next</a>
                    </li>
                </ul>
            </nav>

            <!-- Information Section -->
            <div class="card mt-4 mb-5" style="border-left: 4px solid var(--accent-color);">
                <div class="card-body">
                    <h5 class="card-title" style="color: var(--accent-color);">
                        <i class="fas fa-info-circle me-2"></i>Application Information
                    </h5>
                    <p class="mb-2">Before applying, please ensure you have the following documents ready:</p>
                    <ul class="mb-3">
                        <li>Comprehensive Curriculum Vitae (CV)</li>
                        <li>All relevant academic certificates and transcripts</li>
                        <li>NYSC Discharge Certificate or Exemption Letter</li>
                        <li>Birth Certificate or Declaration of Age</li>
                        <li>Local Government Identification</li>
                        <li>Professional License (where applicable)</li>
                    </ul>
                    <p class="text-muted small mb-0">
                        <i class="fas fa-exclamation-triangle me-1"></i>
                        All documents should be in PDF format and not exceed 5MB each. Incomplete applications will not be considered.
                    </p>
                </div>
            </div>

        </div>

        <%@include file="WEB-INF/jspf/footer.jspf"%>
        <%@include file="WEB-INF/jspf/footerjs.jspf"%>

        <script>
            // Search and Filter Functionality
            document.addEventListener('DOMContentLoaded', function () {
                const searchInput = document.getElementById('searchInput');
                const departmentFilter = document.getElementById('departmentFilter');
                const typeFilter = document.getElementById('typeFilter');
                const vacancyCards = document.querySelectorAll('.vacancy-card');

                function filterVacancies() {
                    const searchTerm = searchInput.value.toLowerCase();
                    const department = departmentFilter.value.toLowerCase();
                    const type = typeFilter.value.toLowerCase();

                    vacancyCards.forEach(card => {
                        const title = card.querySelector('.vacancy-title').textContent.toLowerCase();
                        const dept = card.querySelector('.vacancy-meta').textContent.toLowerCase();
                        const badges = Array.from(card.querySelectorAll('.badge-custom'))
                                .map(b => b.textContent.toLowerCase()).join(' ');

                        const matchesSearch = title.includes(searchTerm) || dept.includes(searchTerm);
                        const matchesDept = !department || dept.includes(department);
                        const matchesType = !type || badges.includes(type);

                        if (matchesSearch && matchesDept && matchesType) {
                            card.style.display = 'block';
                        } else {
                            card.style.display = 'none';
                        }
                    });

                    // Check if any vacancies are visible
                    const visibleCards = Array.from(vacancyCards).filter(card => card.style.display !== 'none');
                    if (visibleCards.length === 0) {
                        showNoResults();
                    } else {
                        hideNoResults();
                    }
                }

                function showNoResults() {
                    let noResults = document.getElementById('noResultsMessage');
                    if (!noResults) {
                        noResults = document.createElement('div');
                        noResults.id = 'noResultsMessage';
                        noResults.className = 'no-vacancies';
                        noResults.innerHTML = `
                            <i class="fas fa-search"></i>
                            <h3>No Matching Vacancies</h3>
                            <p class="text-muted">Try adjusting your search criteria or filters.</p>
                        `;
                        document.getElementById('vacanciesList').appendChild(noResults);
                    }
                }

                function hideNoResults() {
                    const noResults = document.getElementById('noResultsMessage');
                    if (noResults) {
                        noResults.remove();
                    }
                }

                // Add event listeners
                searchInput.addEventListener('input', filterVacancies);
                departmentFilter.addEventListener('change', filterVacancies);
                typeFilter.addEventListener('change', filterVacancies);

                // Check for urgent deadlines and add animation
                const today = new Date();
                document.querySelectorAll('.deadline-badge').forEach(badge => {
                    const deadlineText = badge.textContent;
                    // Add logic here to parse deadline and compare with today
                    // For now, manually marked urgent in HTML
                });
            });
        </script>

    </body>
</html>
