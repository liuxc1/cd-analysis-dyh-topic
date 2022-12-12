package ths.project.api.satelliteRemoteSensing.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.project.api.satelliteRemoteSensing.mapper.SatelliteRemoteSensingMapper;
import java.util.HashMap;

@Service
public class SatelliteRemoteSensingService {

    @Autowired
    private SatelliteRemoteSensingMapper satelliteRemoteSensingMapper;


    public HashMap<String,Object> querySatelliteRemoteSensing() {
        return satelliteRemoteSensingMapper.querySatelliteRemoteSensing();
    }
}
