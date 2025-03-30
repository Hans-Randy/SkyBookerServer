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
    TYPE FlightRecord IS RECORD (
    FlightID Flight.FlightID%TYPE,
    FlightNumber Flight.FlightNumber%TYPE,
    DepartureAirportID Flight.DepartureAirportID%TYPE,
    DepartureAirport Airport.AirportName%TYPE,
    DepartureCity Airport.City%TYPE,
    ArrivalAirportID Flight.ArrivalAirportID%TYPE,
    ArrivalAirport Airport.AirportName%TYPE,
    ArrivalCity Airport.City%TYPE,
    DepartureDateTime Flight.DepartureDateTime%TYPE,
    ArrivalDateTime Flight.ArrivalDateTime%TYPE,
    Price Flight.Price%TYPE,
    AircraftID Flight.AircraftID%TYPE,
    AircraftModel Aircraft.AircraftModel%TYPE
    );
    v_FlightRecord FlightRecord;
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
    TYPE FlightRecord IS RECORD (
    FlightID Flight.FlightID%TYPE,
    FlightNumber Flight.FlightNumber%TYPE,
    DepartureAirportID Flight.DepartureAirportID%TYPE,
    DepartureAirport Airport.AirportName%TYPE,
    DepartureCity Airport.City%TYPE,
    ArrivalAirportID Flight.ArrivalAirportID%TYPE,
    ArrivalAirport Airport.AirportName%TYPE,
    ArrivalCity Airport.City%TYPE,
    DepartureDateTime Flight.DepartureDateTime%TYPE,
    ArrivalDateTime Flight.ArrivalDateTime%TYPE,
    Price Flight.Price%TYPE,
    AircraftID Flight.AircraftID%TYPE,
    AircraftModel Aircraft.AircraftModel%TYPE
    );
    v_FlightRecord FlightRecord;
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
    TYPE FlightRecord IS RECORD (
    FlightID Flight.FlightID%TYPE,
    FlightNumber Flight.FlightNumber%TYPE,
    DepartureAirportID Flight.DepartureAirportID%TYPE,
    DepartureAirport Airport.AirportName%TYPE,
    DepartureCity Airport.City%TYPE,
    ArrivalAirportID Flight.ArrivalAirportID%TYPE,
    ArrivalAirport Airport.AirportName%TYPE,
    ArrivalCity Airport.City%TYPE,
    DepartureDateTime Flight.DepartureDateTime%TYPE,
    ArrivalDateTime Flight.ArrivalDateTime%TYPE,
    Price Flight.Price%TYPE,
    AircraftID Flight.AircraftID%TYPE,
    AircraftModel Aircraft.AircraftModel%TYPE
    );
    v_FlightRecord FlightRecord;
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
    TYPE FlightRecord IS RECORD (
    FlightID Flight.FlightID%TYPE,
    FlightNumber Flight.FlightNumber%TYPE,
    DepartureAirportID Flight.DepartureAirportID%TYPE,
    DepartureAirport Airport.AirportName%TYPE,
    DepartureCity Airport.City%TYPE,
    ArrivalAirportID Flight.ArrivalAirportID%TYPE,
    ArrivalAirport Airport.AirportName%TYPE,
    ArrivalCity Airport.City%TYPE,
    DepartureDateTime Flight.DepartureDateTime%TYPE,
    ArrivalDateTime Flight.ArrivalDateTime%TYPE,
    Price Flight.Price%TYPE,
    AircraftID Flight.AircraftID%TYPE,
    AircraftModel Aircraft.AircraftModel%TYPE
    );
    v_FlightRecord FlightRecord;
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


