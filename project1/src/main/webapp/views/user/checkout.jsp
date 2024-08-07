<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="keywords" content="">
<meta name="description" content="">
<meta name="author" content="">
<title>주문서</title>
<!-- 여기에 필요한 CSS 파일들을 링크합니다 -->
<link rel="shortcut icon" href="../../images/favicon.ico" type="image/x-icon">
<link rel="apple-touch-icon" href="../../images/apple-touch-icon.png">
<link rel="stylesheet" href="../../css/bootstrap.min.css">
<link rel="stylesheet" href="../../css/style.css">
<link rel="stylesheet" href="../../css/responsive.css">
<link rel="stylesheet" href="../../css/custom.css">
<link rel="stylesheet" href="../../css/search.css">
<link rel="stylesheet" href="../../css/loginEnd.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" integrity="sha512-..." crossorigin="anonymous" />
    
</head>

<body>
    <!-- Start Main Top -->

	<%@ include file="../include/nav.jsp" %>

    <!-- Start All Title Box -->
    <div class="all-title-box">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <h2>주문서 작성</h2>
                </div>
            </div>
        </div>
    </div>
    <!-- End All Title Box -->

    <!-- Start Cart  -->
    
<%@ page import="com.project.user.vo.User, com.project.user.vo.Cart, com.project.user.vo.ShipList, java.util.*"%>

<% 
    User userLogin = (User) session.getAttribute("user"); 
    int totalPrice = (Integer) request.getAttribute("totalPrice");
    List<ShipList> shipList = (List<ShipList>) request.getAttribute("shipList");
    String[] prodNos = (String[]) request.getAttribute("prodNos");
    String[] prodQuantity = (String[]) request.getAttribute("prodQuantity");
%>

<form id="checkoutForm" action="/order/processCheckOut" method="post" novalidate onsubmit="return validateForm()">
    <% for (String item : prodNos) { %>
        <input type="hidden" name="prodNos" value="<%= item %>">
    <% } %>
    <% for (String quantity : prodQuantity) { %>
        <input type="hidden" name="prodQuantity" value="<%= quantity %>">
    <% } %>

    <input type="hidden" id="user_no" name="user_no" value="<%= user.getUser_no() %>">
    <input type="hidden" id="totalPrice" name="totalPrice" value="<%= totalPrice %>">

    <div class="cart-box-main">
        <div class="container">
            <div class="row">
                <div class="col-sm-6 col-lg-6 mb-3">
                    <div class="checkout-address">
                        <div class="title-left">
                            <h3>주문 정보 입력란</h3>
                        </div>
                        <div class="mb-3">
                            <label for="username">주문자 성함</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="username" value="<%= user.getUser_name() %>" readonly>
                                <div class="invalid-feedback" style="width: 100%;">Your username is required.</div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="phone_number">주문자 핸드폰 번호</label>
                            <input type="text" class="form-control" id="phone_number" value="<%= user.getUser_mobile() %>" readonly>
                            <div class="invalid-feedback">Please enter your phone number.</div>
                        </div>
                        <div class="mb-3">
                            <label for="email">주문자 이메일</label>
                            <input type="email" class="form-control" id="email" value="<%= user.getUser_email() %>" readonly>
                            <div class="invalid-feedback">Please enter a valid email address for shipping updates.</div>
                        </div>
                        <hr class="my-1">
                        <br>
                        <div class="mb-3">
                            <label for="ship_no">배송지 별칭</label><a href="/ship/shipList" id="shipLink" class="a_href btn btn-primary btn-sm">배송지 관리</a>
                            <select class="wide w-100" id="ship_no" name="ship_no">
                                <option value="option0" data-display="Select">선택</option>
                                <% for (ShipList ship : shipList) { %>
                                    <option value="<%= ship.getShip_no() %>"><%= ship.getShip_alias() %></option>
                                <% } %>
                            </select>
                            <div class="invalid-feedback">Please enter your shipping alias.</div>
                        </div>
                        <div class="mb-3">
                            <label for="ship_comment">배송시 요청 사항</label>
                            <select class="wide w-100" id="ship_comment" name="order_comment" onchange="toggleCustomComment()">
                                <option value="option0">없음</option>
                                <option value="문 앞에 두고 가주세요.">문 앞에 두고 가주세요.</option>
                                <option value="경비실에 맡겨 주세요.">경비실에 맡겨 주세요.</option>
                                <option value="배송 전 연락 주세요.">배송 전 연락 주세요.</option>
                                <option value="option4">직접 작성</option>
                            </select>
                            <input type="text" class="form-control" id="custom_comment" name="custom_comment" placeholder="직접 입력" style="display: none;">
                            <div class="invalid-feedback">Please enter your shipping alias.</div>
                        </div>
                        <hr class="mb-1">
                    </div>
                </div>
                
                <div class="col-sm-6 col-lg-6 mb-3">
                    <div class="row">
                        <div class="col-md-12 col-lg-12">
                            <div class="order-box">
                                <div class="title-left">
                                    <h3>결제 금액</h3>
                                </div>
                                <div class="d-flex">
                                    <h4>상품 금액</h4>
                                    <div class="ml-auto font-weight-bold"><%= totalPrice %>원</div>
                                </div>
                                <div class="d-flex">
                                    <h4>배송비</h4>
                                    <div class="ml-auto font-weight-bold">무료</div>
                                </div>
                                <hr>
                                <div class="d-flex gr-total">
                                    <h5>최종 결제 금액</h5>
                                    <div class="ml-auto h5"><%= totalPrice %>원</div>
                                </div>
                                <hr>
                            </div>
                            <div class="custom-control custom-checkbox">
                                <input type="checkbox" class="custom-control-input" id="order_check1" required>
                                <label class="custom-control-label" for="order_check1">[결제완료] 상태일 경우에만 주문 취소가 가능하며, 이에 동의합니다.</label>
                            </div>
                            <div class="custom-control custom-checkbox">
                                <input type="checkbox" class="custom-control-input" id="order_check2" required>
                                <label class="custom-control-label" for="order_check2">결제 전 주문정보를 확인하였으며 결제에 동의합니다.</label>
                            </div>
                            <div class="col-12 d-flex shopping-box">
                      			<a href="javascript:submitOrderForm()" class="ml-auto btn hvr-hover">결제하기</a>
    	        			</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
	document.addEventListener('DOMContentLoaded', function() {
	    var shipLink = document.getElementById('shipLink');
	    shipLink.addEventListener('click', function(event) {
	        event.preventDefault();
	        var confirmResult = confirm("이 페이지를 벗어나면 장바구니를 다시 선택해야 합니다. 이동하시겠습니까?");
	        if (confirmResult) {
	            window.location.href = shipLink.href;
	        } else {
	            // '아니오' 클릭했을 경우
	        }
	    });
	});
	
    function toggleCustomComment() {
        var ship_comment = $('#ship_comment').val();
        if (ship_comment === 'option4') {
            $('#custom_comment').show().attr('name', 'order_comment');
            $('#ship_comment').removeAttr('name');
        } else {
            $('#custom_comment').hide().removeAttr('name');
            $('#ship_comment').attr('name', 'order_comment');
        }
    }
    
    function validateForm() {
        var ship_no = document.getElementById('ship_no').value;
        var order_check1 = document.getElementById('order_check1').checked;
        var order_check2 = document.getElementById('order_check2').checked;

        if (ship_no === 'option0') {
            alert('배송지를 선택해주세요.');
            return false;
        }

        if (!order_check1 || !order_check2) {
            alert('체크박스를 모두 선택해주세요.');
            return false;
        }

        return true;
    }

    function submitOrderForm() {
	    if (validateForm()) {
	        document.getElementById("checkoutForm").submit();
	    }
	}
</script>
    <!-- End Cart -->

    <!-- Start footer  -->
	<%@ include file="../include/footer.jsp" %>

</body>

</html>