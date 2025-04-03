-- Test AddPassenger Procedure
BEGIN
    AirlinePackage.AddPassenger('John Doe', 'john.doe@example.com', '1234567890', 'JD123456');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('AddPassenger procedure executed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK; 
END;
/

-- Test UpdateFlightPrice Procedure
BEGIN
    AirlinePackage.UpdateFlightPrice(1, 2000.00);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('UpdateFlightPrice procedure executed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK; 
END;
/

-- Test GetPassengerCount Function
DECLARE
    v_PassengerCount NUMBER;
BEGIN
    v_PassengerCount := AirlinePackage.GetPassengerCount;
    DBMS_OUTPUT.PUT_LINE('Passenger Count: ' || v_PassengerCount);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Test GetFlightPrice Function
DECLARE
    v_FlightPrice NUMBER;
BEGIN
    v_FlightPrice := AirlinePackage.GetFlightPrice(1);
    DBMS_OUTPUT.PUT_LINE('Flight Price: ' || v_FlightPrice);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Test AddBooking Procedure and g_LastBookingID Variable
BEGIN
    AirlinePackage.AddBooking(1, 1);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('AddBooking procedure executed successfully.');
    DBMS_OUTPUT.PUT_LINE('Booking ID: ' || AirlinePackage.g_LastBookingID);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK; 
END;
/

-- Test GetOccupiedSeatsCount Function
DECLARE
    v_OccupiedSeatsCount NUMBER;
BEGIN
    v_OccupiedSeatsCount := AirlinePackage.GetOccupiedSeatsCount(1);
    DBMS_OUTPUT.PUT_LINE('Occupied Seats Count for Flight 1: ' || v_OccupiedSeatsCount);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Test ListFlightsByAirport Procedure
DECLARE
    v_cursor SYS_REFCURSOR;
    v_flightNumber Flight.FlightNumber%TYPE;
    v_departureTime Flight.DepartureDateTime%TYPE;
    v_arrivalTime Flight.ArrivalDateTime%TYPE;
    v_price Flight.Price%TYPE;
BEGIN

    DBMS_OUTPUT.PUT_LINE('Flights departing from JFK (Airport ID 1):');
    AirlinePackage.ListFlightsByAirport(1, v_cursor);
    
    LOOP
        FETCH v_cursor INTO v_flightNumber, v_departureTime, v_arrivalTime, v_price;
        EXIT WHEN v_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Flight: ' || v_flightNumber || 
                           ' | Departure: ' || TO_CHAR(v_departureTime, 'YYYY-MM-DD HH24:MI') ||
                           ' | Arrival: ' || TO_CHAR(v_arrivalTime, 'YYYY-MM-DD HH24:MI') ||
                           ' | Price: $' || v_price);
    END LOOP;
    IF v_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No flights found for this airport ID.');
    END IF;
    CLOSE v_cursor;    
END;
/

-- Test SearchFlights with departure airport only
DECLARE
    v_cursor AirlinePackage.FlightCursorType;
    v_FlightRecord AirlinePackage.FlightRecord;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing SearchFlights with departure airport only:');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    
    AirlinePackage.SearchFlights(1, v_cursor);
    
    LOOP
        FETCH v_cursor INTO v_FlightRecord;
        EXIT WHEN v_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Flight: ' || v_FlightRecord.FlightNumber || 
                           ' | From: ' || v_FlightRecord.DepartureAirport ||
                           ' | To: ' || v_FlightRecord.ArrivalAirport ||
                           ' | Departure: ' || v_FlightRecord.DepartureDateTime ||
                           ' | Arrival: ' || v_FlightRecord.ArrivalDateTime ||
                           ' | Price: $' || v_FlightRecord.Price);
    END LOOP;
    
    CLOSE v_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF v_cursor%ISOPEN THEN
            CLOSE v_cursor;
        END IF;
END;
/

-- Test SearchFlights with departure and arrival airports
DECLARE
    v_cursor AirlinePackage.FlightCursorType;
    v_FlightRecord AirlinePackage.FlightRecord;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing SearchFlights with departure and arrival airports:');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    
    AirlinePackage.SearchFlights(1, 2, v_cursor);
    
    LOOP
        FETCH v_cursor INTO v_FlightRecord;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Flight: ' || v_FlightRecord.FlightNumber || 
                           ' | From: ' || v_FlightRecord.DepartureAirport ||
                           ' | To: ' || v_FlightRecord.ArrivalAirport ||
                           ' | Departure: ' || v_FlightRecord.DepartureDateTime ||
                           ' | Arrival: ' || v_FlightRecord.ArrivalDateTime ||
                           ' | Price: $' || v_FlightRecord.Price);
    END LOOP;
    
    CLOSE v_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF v_cursor%ISOPEN THEN
            CLOSE v_cursor;
        END IF;
END;
/

-- Test SearchFlights with departure airport and date
DECLARE
    v_cursor AirlinePackage.FlightCursorType;
    v_FlightRecord AirlinePackage.FlightRecord;
    v_departureDate DATE := TO_DATE('2025-03-15', 'YYYY-MM-DD');
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing SearchFlights with departure airport and date:');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    
    AirlinePackage.SearchFlights(1, v_departureDate, v_cursor);
    
    LOOP
        FETCH v_cursor INTO v_FlightRecord;
        EXIT WHEN v_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Flight: ' || v_FlightRecord.FlightNumber || 
                           ' | From: ' || v_FlightRecord.DepartureAirport ||
                           ' | To: ' || v_FlightRecord.ArrivalAirport ||
                           ' | Departure: ' || v_FlightRecord.DepartureDateTime ||
                           ' | Arrival: ' || v_FlightRecord.ArrivalDateTime ||
                           ' | Price: $' || v_FlightRecord.Price);
    END LOOP;
    
    CLOSE v_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF v_cursor%ISOPEN THEN
            CLOSE v_cursor;
        END IF;
END;
/

-- Test SearchFlights with departure airport, arrival airport, and date
DECLARE
    v_cursor AirlinePackage.FlightCursorType;
    v_FlightRecord AirlinePackage.FlightRecord;
    v_departureDate DATE := TO_DATE('2025-03-15', 'YYYY-MM-DD');
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing SearchFlights with departure airport, arrival airport, and date:');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    
    AirlinePackage.SearchFlights(1, 2, v_departureDate, v_cursor);
    
    LOOP
        FETCH v_cursor INTO v_FlightRecord;
        EXIT WHEN v_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Flight: ' || v_FlightRecord.FlightNumber || 
                           ' | From: ' || v_FlightRecord.DepartureAirport ||
                           ' | To: ' || v_FlightRecord.ArrivalAirport ||
                           ' | Departure: ' || v_FlightRecord.DepartureDateTime ||
                           ' | Arrival: ' || v_FlightRecord.ArrivalDateTime ||
                           ' | Price: $' || v_FlightRecord.Price);
    END LOOP;
    
    CLOSE v_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF v_cursor%ISOPEN THEN
            CLOSE v_cursor;
        END IF;
END;
/

-- Test GetNextAvailableSeat Function
DECLARE
    v_SeatID NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing GetNextAvailableSeat:');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    
    v_SeatID := AirlinePackage.GetNextAvailableSeat(1);
    DBMS_OUTPUT.PUT_LINE('Next available seat ID for Flight 1: ' || v_SeatID);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Test SearchFlightsByPassenger Procedure
DECLARE
    v_cursor AirlinePackage.PassengerFlightCursorType;
    v_FlightRecord AirlinePackage.PassengerFlightRecord;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing SearchFlightsByPassenger:');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    
    AirlinePackage.SearchFlightsByPassenger(2, v_cursor);
    
    LOOP
        FETCH v_cursor INTO v_FlightRecord;
        EXIT WHEN v_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Flight: ' || v_FlightRecord.FlightNumber || 
                           ' | From: ' || v_FlightRecord.DepartureAirport ||
                           ' | To: ' || v_FlightRecord.ArrivalAirport ||
                           ' | Departure: ' || v_FlightRecord.DepartureDateTime ||
                           ' | Arrival: ' || v_FlightRecord.ArrivalDateTime ||
                           ' | Price: $' || v_FlightRecord.Price ||
                           ' | Booking Status: ' || v_FlightRecord.BookingStatus ||
                           ' | Seat: ' || v_FlightRecord.SeatNumber);
    END LOOP;
    
    CLOSE v_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF v_cursor%ISOPEN THEN
            CLOSE v_cursor;
        END IF;
END;
/

-- Test GetAvailableSeats Procedure
DECLARE
    v_cursor SYS_REFCURSOR;
    v_SeatID Aircraft_Seat.SeatID%TYPE;
    v_SeatNumber Aircraft_Seat.SeatNumber%TYPE;
    v_SeatRow Aircraft_Seat.SeatRow%TYPE;
    v_SeatColumn Aircraft_Seat.SeatColumn%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing GetAvailableSeats:');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    
    AirlinePackage.GetAvailableSeats(1, v_cursor);
    
    LOOP
        FETCH v_cursor INTO v_SeatID, v_SeatNumber, v_SeatRow, v_SeatColumn;
        EXIT WHEN v_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Available Seat: ' || v_SeatNumber || 
                           ' | Row: ' || v_SeatRow ||
                           ' | Column: ' || v_SeatColumn);
    END LOOP;
    
    CLOSE v_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF v_cursor%ISOPEN THEN
            CLOSE v_cursor;
        END IF;
END;
/

-- Test AddFlight Procedure
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing AddFlight:');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    
    AirlinePackage.AddFlight(
        'TEST123',
        1,  -- Departure Airport ID
        2,  -- Arrival Airport ID
        1,  -- Aircraft ID
        TO_TIMESTAMP('2025-03-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_TIMESTAMP('2025-03-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        500.00
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Flight added successfully');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/

-- Test UpdateFlight Procedure
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing UpdateFlight:');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    
    AirlinePackage.UpdateFlight(
        1,  -- Flight ID
        'UPD123',
        1,  -- Departure Airport ID
        2,  -- Arrival Airport ID
        TO_TIMESTAMP('2025-03-21 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        TO_TIMESTAMP('2025-03-21 12:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        600.00
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Flight updated successfully');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/

-- Test UpdateBooking Procedure
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing UpdateBooking:');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    
    -- First, get an available seat
    DECLARE
        v_NewSeatID NUMBER;
    BEGIN
        v_NewSeatID := AirlinePackage.GetNextAvailableSeat(1);
        
        -- Update the booking with the new seat
        AirlinePackage.UpdateBooking(1, v_NewSeatID, 'Confirmed');
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Booking updated successfully with new seat: ' || v_NewSeatID);
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/


