package com.project.user.controller.orderList;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.project.user.service.OrderService;
import com.project.user.vo.User;


@WebServlet("/order/processCheckOut")
public class ProcessCheckoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public ProcessCheckoutServlet() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("/views/user/login.jsp");
                return;
            }

            int user_no = user.getUser_no();
            int totalPrice = Integer.parseInt(request.getParameter("totalPrice"));
            int ship_no = Integer.parseInt(request.getParameter("ship_no"));

            String[] prodNosStr = request.getParameterValues("prodNos");
            String[] prodQuantitiesStr = request.getParameterValues("prodQuantity");

            if (prodNosStr == null || prodQuantitiesStr == null) {
                throw new ServletException("상품 번호 또는 수량이 전달되지 않았습니다.");
            }

            int[] prodNos = new int[prodNosStr.length];
            int[] prodQuantities = new int[prodQuantitiesStr.length];

            for (int i = 0; i < prodNosStr.length; i++) {
                prodNos[i] = Integer.parseInt(prodNosStr[i]);
                prodQuantities[i] = Integer.parseInt(prodQuantitiesStr[i]);
            }

            String order_comment = request.getParameter("order_comment");
            if (order_comment == null) {
                order_comment = "";
            }
            
            String order_no = generateOrderNo();
            System.out.println("order_no: "+order_no);
            String reason = "상품 구매";
            
            
            int minusPoint = -totalPrice;
            int result = OrderService.OrderProcess(user_no, totalPrice, ship_no, prodNos, prodQuantities, order_comment, order_no);
            if (result > 0) {
                OrderService.deleteCartItems(user_no, prodNos); //  포인트 차감까지 성공시 장바구니 내역 삭제
                new OrderService().insertPointChange(user_no, reason, minusPoint);  // 포인트 변동 테이블에 내역 insert
                response.sendRedirect("/views/user/order-complete.jsp");

            } else {
                response.sendRedirect("/views/user/order_fail.jsp");  // 포인트 부족시 fail
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 오류가 발생했습니다.");
        }
    }
	
	
	    private String generateOrderNo() {
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MMdd-HHmmss");
	        return sdf.format(new Date()) + (int)(Math.random() * 1000);
	    }


}