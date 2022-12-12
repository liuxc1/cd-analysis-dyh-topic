package ths.project.api.env_emergency.vo;

public class EmergencyShelterVo {

    private Integer kuiChongNum;

    private Integer daPengNum;

    private Integer nanAoNum;

    public Integer getKuiChongNum() {
        return kuiChongNum;
    }

    public void setKuiChongNum(Integer kuiChongNum) {
        this.kuiChongNum = kuiChongNum;
    }

    public Integer getDaPengNum() {
        return daPengNum;
    }

    public void setDaPengNum(Integer daPengNum) {
        this.daPengNum = daPengNum;
    }

    public Integer getNanAoNum() {
        return nanAoNum;
    }

    public void setNanAoNum(Integer nanAoNum) {
        this.nanAoNum = nanAoNum;
    }

    public EmergencyShelterVo(Integer kuiChongNum, Integer daPengNum, Integer nanAoNum) {
        this.kuiChongNum = kuiChongNum;
        this.daPengNum = daPengNum;
        this.nanAoNum = nanAoNum;
    }

    public EmergencyShelterVo() {
    }
}
